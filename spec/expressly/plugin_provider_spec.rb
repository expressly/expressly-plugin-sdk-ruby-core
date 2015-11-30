require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'open-uri'
require 'expressly/plugin_provider'

module Expressly

  describe "MerchantPluginProvider" do

    it "can do something" do
      router = Expressly::TestAbstract.new()
      #router.change_gear(1)
    end

  end
end
