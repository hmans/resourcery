require 'spec_helper'

class User
end

class UsersController < ApplicationController
  respond_to :html
  serve_resource
end

describe UsersController, type: :controller do
  describe '#index' do
    it "should set the @foos instance variable" do
      User.should_receive(:scoped).and_return(@users = double)
      get :index
      expect(assigns(:users)).to eq(@users)
    end
  end
end
