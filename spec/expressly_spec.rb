require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'open-uri'
require 'expressly'

module Expressly

  describe "Expressly" do
    it "can have a default config set" do
      config = Configuration.new(
          'api_key',
          'merchant_plugin_provider',
          'merchant_plugin_endpoint')


      Expressly.default_configuration.nil?.should == true
      Expressly.default_configuration?.should == false

      Expressly.default_configuration = config

      Expressly.default_configuration.should == config
      Expressly.default_configuration?.should == true
    end
  end

  describe "Configuration" do
    it "is initialised correctly" do
      config = Configuration.new(
          'api_key',
          'merchant_plugin_provider',
          'merchant_plugin_endpoint',
          'merchant_metadata',
          'expressly_endpoint')

      config.api_key.should == 'api_key'
      config.merchant_plugin_provider.should == 'merchant_plugin_provider'
      config.merchant_plugin_endpoint.should == 'merchant_plugin_endpoint'
      config.merchant_metadata.should == 'merchant_metadata'
      config.expressly_endpoint.should == 'expressly_endpoint'
    end

    it "is initialised correctly with defaults" do
      config = Configuration.new(
          'api_key',
          'merchant_plugin_provider',
          'merchant_plugin_endpoint')

      config.api_key.should == 'api_key'
      config.merchant_plugin_provider.should == 'merchant_plugin_provider'
      config.merchant_plugin_endpoint.should == 'merchant_plugin_endpoint'
      config.merchant_metadata.should == {}
      config.expressly_endpoint.should == 'https://prod.expresslyapp.com/api'
    end
  end
end
