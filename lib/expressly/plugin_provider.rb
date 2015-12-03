module Expressly
  ##
  # This "interface" should be "implemented" by you and provided to the Expressly::Configuration constructor. 
  # It is the bridge between the expressly domain and your platform.
  #
  class MerchantPluginProvider
    include AbstractInterface
    
    ##
    # The popup_handler is called when a prospective customer has clicked on a campaign promotion 
    # and been directed to your shop. You are required to make a call to retrieve the expressly popup html
    # and embed it on the landing page of your choice.
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

end