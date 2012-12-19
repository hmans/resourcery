require 'spec_helper'

describe 'controller extensions', type: :controller do
  let(:collection) { User }
  let(:resource)   { mock_model User }
  let(:resource_with_errors) { mock_model User, errors: { name: "is not allowed" } }

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

      it "should render the 'index' view" do
        expect(response).to render_template('index')
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

      it "should render the 'show' view" do
        expect(response).to render_template('show')
      end
    end

    describe 'GET edit' do
      before do
        User.should_receive(:find).with("123").and_return(resource)
        get :edit, id: 123
      end

      it "should set resource ivar" do
        expect(assigns(:user)).to eq(resource)
      end

      it "should render the 'edit' view" do
        expect(response).to render_template('edit')
      end
    end

    describe 'POST create' do
      let(:user_attributes) { { "name" => "Hendrik", "admin" => true } }

      before do
        User.should_receive(:new).with(user_attributes).and_return(resource)
        resource.should_receive(:save)

        post :create, user: user_attributes
      end

      context "when the resource was created successfully" do
        it "should set resource ivar" do
          expect(assigns(:user)).to eq(resource)
        end

        it "should redirect to the resource path" do
          expect(response).to redirect_to user_path(resource)
        end
      end

      context "when the resource could not be created" do
        let(:resource) { resource_with_errors }

        it "should set resource ivar" do
          expect(assigns(:user)).to eq(resource)
        end

        it "should render the 'new' view" do
          expect(response).to render_template('new')
        end
      end
    end

  end
end
