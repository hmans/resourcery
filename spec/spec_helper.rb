require 'rubygems'
require 'bundler/setup'

ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# load dependencies
# require 'rails'
# require 'active_support'
# require 'active_model'
# require 'action_controller'

require 'rspec/rails'


# load resourcery
# require 'resourcery'




RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.order = "random"
end
