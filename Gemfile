
source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
gem "bundler"
gem 'httpclient'


# gem 'tzinfo-data'
# gem 'awesome_print', '~> 1.2.0'
gem 'tzinfo', '0.3.37'

group :development do
  require 'rbconfig'
  gem 'guard-rspec'
  gem 'guard'
  gem "rdoc", "~> 3.12"
  gem 'wdm', '>= 0.1.0' if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
end
