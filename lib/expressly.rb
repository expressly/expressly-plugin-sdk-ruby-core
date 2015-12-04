require 'logger'

module Expressly
  @@logger = Logger.new(STDERR)
  @@logger.level= Logger::Severity::INFO
  
  def self.logger() @@logger end
  def self.logger=(logger) @@logger = logger end

  @@default_configuration = nil
  def self.default_configuration() 
    @@default_configuration 
  end
  
  def self.default_configuration?() 
    @@default_configuration != nil
  end

  ##
  # Set the default configuration. This is how the ApiController so you must call this with your configuration .
  #
  # === Args
  #
  # * +default_configuration+ - an Expressly::Configuration instance
  #
  def self.default_configuration=(default_configuration)
    @@default_configuration = default_configuration 
  end

  ##
  # The configuration object for boot strapping the Expressly plugin engine.
  #
  class Configuration
    attr_reader :api_key, 
      :merchant_plugin_provider, :merchant_plugin_endpoint, :merchant_metadata,
      :expressly_provider, :expressly_endpoint

    ##
    # Constructor arguments
    #
    # === Args
    #
    # * +api_key+ - your Expressly API key
    # * +merchant_plugin_provider+ - your Expressly::MerchantPluginProvider implementation
    # * +merchant_plugin_endpoint+ - the http endpoint of your store, i.e. the bit that comes before /expressly/api/...
    # * +merchant_metadata+ - a hash of metadata that may be sent to the server on a customer export
    # * +expressly_endpoint+ - the Expressly server endpoint. Defaults to the Expressly production service.
    #
    def initialize(api_key, merchant_plugin_provider, merchant_plugin_endpoint, merchant_metadata = {}, expressly_endpoint = 'https://prod.expresslyapp.com/api')
      @api_key = api_key
      @merchant_plugin_provider = merchant_plugin_provider
      @merchant_plugin_endpoint = merchant_plugin_endpoint
      @expressly_endpoint = expressly_endpoint
      @expressly_provider = Api.new(api_key, expressly_endpoint)
      @merchant_metadata = merchant_metadata
    end
  end
end

require 'expressly/version'
require 'expressly/util'
require 'expressly/domain'
require 'expressly/api'
require 'expressly/plugin_provider'

begin
  require 'expressly/engine'
rescue NameError
  Expressly.logger.warn('expressly') { 
    "skipping loading of the expressly rails engine" }
end
