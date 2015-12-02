module Expressly
  class MerchantPluginProvider
    include AbstractInterface
    ##
    # Some documentation on the popup_handler method
    #
    def popup_handler(controller, campaign_customer_uuid)
      MerchantPluginProvider.api_not_implemented(self)
    end

    def customer_register(primary_email, customer)
      MerchantPluginProvider.api_not_implemented(self)
    end

    def customer_send_password_reset_email(customer_reference)
      MerchantPluginProvider.api_not_implemented(self)
    end

    def customer_update_cart(customer_reference, cart)
      MerchantPluginProvider.api_not_implemented(self)
    end

    def customer_login(customer_reference)
      MerchantPluginProvider.api_not_implemented(self)
    end

    def customer_migrated_redirect_url(success, customer_reference)
      MerchantPluginProvider.api_not_implemented(self)
    end

    ##
    # Some documentation on the check_customer_statuses method
    # return Expressly::Customer
    def get_customer(email)
      MerchantPluginProvider.api_not_implemented(self)
    end

    ##
    # Some documentation on the check_customer_statuses method
    def check_customer_statuses(email_list)
      MerchantPluginProvider.api_not_implemented(self)
    end

    ##
    # Some documentation on the get_order_details method
    # Returns ...
    def get_customer_invoices(customer_invoice_request_list)
      MerchantPluginProvider.api_not_implemented(self)
    end

  end

  class TestAbstract < MerchantPluginProvider
  end

end