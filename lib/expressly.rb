module Expressly
  @@logger = Logger.new(STDERR)
  @@logger.level= Logger::Severity::INFO
  
  def self.logger() @@logger end
  def self.logger=(logger) @@logger = logger end
end

require 'logger'

require 'expressly/version'
require 'expressly/util'
require 'expressly/domain'
require 'expressly/api'

begin
  require 'expressly/engine'
rescue NameError
  Expressly.logger.warn('expressly') { 
    "skipping loading of the expressly rails engine" }
end
