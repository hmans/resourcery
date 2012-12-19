require 'rubygems'
require 'bundler/setup'

ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'


# we'll use this every now and then
class User
  include ActiveModel::Naming
end


RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.order = "random"
  config.before :each do
    User.stub(:scoped).and_return(User)
  end
end

