require 'rubygems'
require 'bundler/setup'

ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'


# We'll use this every now and then
#
class User
  extend ActiveModel::Naming
end


RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.order = "random"
  config.before :each do
    # Prepare the fake User class.
    #
    User.stub(:scoped).and_return(User)

    # Since we will be working with the fake User class a lot, let's set up
    # some routes since the ActionController::Responder will use them, too.
    #
    routes.draw do
      resources :users
    end
  end
end
