require "base64"

module Expressly

  class MerchantPluginProvider   
    include AbstractInterface
  
    # Some documentation on the change_gear method
    def change_gear(new_value)
      MerchantPluginProvider.api_not_implemented(self)
    end

  end
  
  class TestAbstract < MerchantPluginProvider
  end
  
end