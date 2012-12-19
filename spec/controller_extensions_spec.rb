require 'spec_helper'

describe 'controller extensions', type: :controller do
  let(:resource) { double }
  let(:collection) { double }

  describe 'standard behaviour of REST actions' do
    controller do
      respond_to :html
      serve_resource User
    end

    describe 'GET index' do
      before do
        User.should_receive(:scoped).and_return(collection)
        get :index
      end

      it "should set the collection ivar" do
        expect(assigns(:users)).to eq(collection)
      end
    end

    describe 'GET show' do
      before do
        User.should_receive(:find).with("123").and_return(resource)
        get :show, id: 123
      end

      it "should set resource ivar" do
        expect(assigns(:user)).to eq(resource)
      end
    end

  end
end
