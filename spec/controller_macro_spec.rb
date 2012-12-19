require 'spec_helper'

describe 'serve_resource', type: :controller do
  context "when a resource class is not explicitly specified" do
    class UsersController < ApplicationController
      respond_to :html
      serve_resource
    end

    describe UsersController, type: :controller do
      it "should choose the resource class name based on the controller class name" do
        subject.send(:resource_class).should == User
      end
    end
  end

  context "when explicitly specifying a resource class" do
    describe ApplicationController do
      controller do
        respond_to :html
        serve_resource User
      end

      it 'should set the resource class according to the argument' do
        subject.send(:resource_class).should == User
      end
    end
  end
end
