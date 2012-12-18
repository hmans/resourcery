require 'spec_helper'

class User
  include ActiveModel::Naming
end

class UsersController < ApplicationController
  respond_to :html
  serve_resource

  def allowance
    @allowance ||= Allowance.define do |a|
      a.allow! :read, User
    end
  end
end

describe UsersController do
  it "something" do
    get :index
    true.should be_true
  end
end
