module Expressly
  class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :authenticate
    def ping
      render content_type: "application/json", json: { "expressly" => "Stuff is happening!" }
    end

    def ping_registered
      render content_type: "application/json", json: { "registered" => true }
    end

    def customer_export
      customer = provider.get_customer(params[:email])
      render content_type: "application/json", json: { "what" => "customer_export" }

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
      campaign_customer_uuid = params[:campaign_customer_uuid]
      # get html
      # forward to block in config

      render content_type: "application/json", json: { "what" => "display_popup->#{campaign_customer_uuid}" }
    end

    def migrate
      # migrate the user
      # handle errors
      # redirect_to_write_place
      campaign_customer_uuid = params[:campaign_customer_uuid]
      render content_type: "application/json", json: { "what" => "customer_import->#{campaign_customer_uuid}" }
    end

    def authenticate
      partitionedApiKey = config.api_key.partition(':')
      authenticate_or_request_with_http_basic('expressly') do |username, password|
        username == partitionedApiKey[0] && password == partitionedApiKey[2]
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
