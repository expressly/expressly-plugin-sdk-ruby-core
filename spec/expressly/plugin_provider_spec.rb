require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Expressly

  describe "MerchantPluginProvider" do

    it "reports not implemented error when popup_handler is called" do
      expect { MerchantPluginProvider.new.popup_handler(nil, nil) }.to raise_error
    end

    it "reports not implemented error when customer_register is called" do
      expect { MerchantPluginProvider.new.customer_register(nil, nil) }.to raise_error
    end

    it "reports not implemented error when customer_send_password_reset_email is called" do
      expect { MerchantPluginProvider.new.customer_send_password_reset_email(nil) }.to raise_error
    end

    it "reports not implemented error when customer_update_cart is called" do
      expect { MerchantPluginProvider.new.customer_update_cart(nil, nil) }.to raise_error
    end

    it "reports not implemented error when customer_login is called" do
      expect { MerchantPluginProvider.new.customer_login(nil) }.to raise_error
    end

    it "reports not implemented error when customer_migrated_redirect_url is called" do
      expect { MerchantPluginProvider.new.customer_migrated_redirect_url(nil, nil) }.to raise_error
    end

    it "reports not implemented error when get_customer is called" do
      expect { MerchantPluginProvider.new.get_customer(nil) }.to raise_error
    end

    it "reports not implemented error when check_customer_statuses is called" do
      expect { MerchantPluginProvider.new.check_customer_statuses(nil) }.to raise_error
    end

    it "reports not implemented error when get_customer_invoices is called" do
      expect { MerchantPluginProvider.new.get_customer_invoices(nil) }.to raise_error
    end
  end
end

require 'fakeweb'