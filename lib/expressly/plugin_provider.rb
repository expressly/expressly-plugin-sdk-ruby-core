module Expressly

  class MerchantPluginProvider   
    include AbstractInterface
  
    ##
    # Some documentation on the check_customer_statuses method
    #
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