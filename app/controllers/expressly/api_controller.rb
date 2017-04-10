module Expressly
  class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :authenticate
    skip_before_action :authenticate, only: [:display_popup, :migrate]

    def ping
      render content_type: "application/json", json: { "expressly" => "Stuff is happening!" }
    end

    def registered
      render content_type: "application/json", json: { "registered" => true }
    end

    def customer_export
      customer = provider.get_customer(params[:email]) or raise ActionController::RoutingError.new('Not Found')

      result = Expressly::CustomerExport.new({
        :metadata => config.merchant_metadata,
        :primary_email => params[:email],
        :customer => customer
      })
      render content_type: "application/json", json: JSON.parse(result.to_json)
    end

    def invoices
      result = provider.get_customer_invoices(Expressly::CustomerInvoiceRequest.from_json_list(params[:customers]))
      render content_type: "application/json", json: JSON.parse(Expressly::CustomerInvoice.to_json_from_list(result))
    end

    def check_emails
      result = provider.check_customer_statuses(params[:emails])
      render content_type: "application/json", json: result
    end

    def display_popup
      provider.popup_handler(self, params[:campaign_customer_uuid])
    end

    def migrate
      campaign_customer_uuid = params[:campaign_customer_uuid]
      begin
        import = config.expressly_provider.fetch_customer_data(campaign_customer_uuid)
        customer_reference = provider.customer_register(import.primary_email, import.customer)
        provider.customer_send_password_reset_email(customer_reference)
        unless import.cart.nil?
          provider.customer_update_cart(customer_reference, import.cart)
        end
        provider.customer_login(customer_reference)
        redirect_to "#{config.expressly_endpoint}/redirect/migration/#{campaign_customer_uuid}/success"
      rescue Expressly::ExpresslyError
        # already migrated or invalid uuid so just redirect
        redirect_to "#{config.expressly_endpoint}/redirect/migration/#{campaign_customer_uuid}/failed"
      end
    end

    def authenticate
      partitioned_api_key = config.api_key.partition(':')
      authenticate_or_request_with_http_basic('expressly') do |username, password|
        username == partitioned_api_key[0] && password == partitioned_api_key[2]
      end
    end

    def config
      Expressly::default_configuration
    end

    def provider
      config.merchant_plugin_provider
    end
  end
end
