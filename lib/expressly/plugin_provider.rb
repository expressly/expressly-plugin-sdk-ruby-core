module Expressly
  ##
  # This "interface" should be "implemented" by you and provided to the Expressly::Configuration constructor. 
  # It is the bridge between the expressly domain and your platform. The Expressly::ApiController is responsible
  # for marshalling and routing requests to your platform and directing calls to your specific provider implementation.
  #
  #
  class MerchantPluginProvider
    include AbstractInterface
    
    ##
    # The customer register is the first step of the migration process after they have confirmed that they want to proceed.
    # You should register the customer on you system when you receive this call. You should treat this as a new customer,
    # i.e. send them a welcome email etc.
    #
    # === Args
    #
    # * +primary_email+ - the new customer's identifying e-mail address (note that the emails within the customer object may only contain alternate addresses)
    # * +customer+ - an Expressly::Customer instance with the data of the customer to import
    #
    # === Return
    #
    # The reference you would like to use to further identify the customer within the remaining migration calls. This
    # can be anything that works for you from the email address, the database identifier, to your internal customer object.
    #
    def customer_register(primary_email, customer)
      MerchantPluginProvider.api_not_implemented(self)
    end

    ##
    # You should execute a password reset on behalf of the user and send them an email so that they can reset their
    # password.
    #
    # === Args
    #
    # * +customer_reference+ - the reference you returned in the customer_register call
    #
    # === Return
    #
    # N/A
    #
    def customer_send_password_reset_email(customer_reference)
      MerchantPluginProvider.api_not_implemented(self)
    end

    ##
    # You should update the customer's cart to include the coupon and/or product if either or both are present.
    #
    # === Args
    #
    # * +customer_reference+ - the reference you returned in the customer_register call
    # * +cart+ - an instance of Expressly::Cart with the details of how to update the cart with
    #
    # === Return
    #
    # N/A
    #
    def customer_update_cart(customer_reference, cart)
      MerchantPluginProvider.api_not_implemented(self)
    end

    ##
    # You should log the user in on their current session.
    #
    # === Args
    #
    # * +customer_reference+ - the reference you returned in the customer_register call
    #
    # === Return
    #
    # N/A
    #
    def customer_login(customer_reference)
      MerchantPluginProvider.api_not_implemented(self)
    end

    ##
    # The provider should respond to this call by populating an Expressly::Customer instance with the details of
    # the customer that matches the email address passed to it.
    #
    # === Args
    #
    # * +email+ - the email address of the customer to be exported
    #
    # === Return
    #
    # An instance of Expressly::Customer to be exported. It should attempt to fill in as many fields as possible.
    #
    def get_customer(email)
      MerchantPluginProvider.api_not_implemented(self)
    end

    ##
    # Check the statuses of the email addresses supplied. Given the list the implementer should check for the
    # existence of the email addresses in their system and for those that exist should return an
    # Expressly::CustomerStatuses instance.
    #
    # === Args
    #
    # * +email_list+ - a list of the emails to check.
    #
    # === Return
    #
    # An instance of Expressly::CustomerStatuses.
    #
    def check_customer_statuses(email_list)
      MerchantPluginProvider.api_not_implemented(self)
    end

    ##
    # Retrieve the invoices and orders in a given time frame for the supplied email addresses. Each entry consists
    # of the email address, a from date (inclusive) and a to date (exclusive)
    #
    # === Args
    #
    # * +customer_invoice_request_list+ - a list of Expressly::CustomerInvoiceRequest objects.
    #
    # === Return
    #
    # A list of Expressly::CustomerInvoice objects for all the customers referenced in the request.
    #
    def get_customer_invoices(customer_invoice_request_list)
      MerchantPluginProvider.api_not_implemented(self)
    end

  end

end