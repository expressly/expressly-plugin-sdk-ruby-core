module Expressly
  @@logger = Logger.new(STDERR)
  @@logger.level= Logger::Severity::INFO
  
  def self.logger() @@logger end
  def self.logger=(logger) @@logger = logger end
    
  def self.default_configuration() 
    @@default_configuration 
  end
  
  def self.default_configuration?() 
    !@@default_configuration.nil?
  end
  
  def self.default_configuration=(default_configuration) 
    @@default_configuration = default_configuration 
  end
  
  class Configuration
    attr_reader :api_key, 
      :merchant_plugin_provider, :merchant_plugin_endpoint, :merchant_metadata,
      :expressly_provider, :expressly_endpoint
    
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

require 'logger'

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
