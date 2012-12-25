require 'spec_helper'

describe 'serve_resource', type: :controller do
  shared_examples "a controller serving the User class" do
    it "serves the User class" do
      subject.send(:resource_class).should == User
    end
  end

  context "when a resource class is not explicitly specified" do
    class UsersController < ApplicationController
      serve_resource
    end

    describe UsersController, type: :controller do
      it_behaves_like "a controller serving the User class"
    end
  end

  context "when explicitly specifying a resource class" do
    controller do
      serve_resource User
    end

    it_behaves_like "a controller serving the User class"
  end

  context "when specifying the resource class as a symbol" do
    context "when symbol is singular" do
      controller do
        serve_resource :user
      end

      it_behaves_like "a controller serving the User class"
    end

    context "when symbol is plural" do
      controller do
        serve_resource :users
      end

      it_behaves_like "a controller serving the User class"
    end
  end
end
