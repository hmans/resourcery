module Resourcery
  class AccessDenied < StandardError ; end

  module InstanceMethods
    def index
      respond_with collection
    end

    def show
      respond_with resource
    end

    def edit
      respond_with resource
    end

    def update
      resource.update_attributes(params[singular_resource_name])
      respond_with resource
    end

    def new
      respond_with collection.new
    end

    def create
      @user = collection.new(params[singular_resource_name])
      @user.save
      respond_with @user
    end

    def destroy
      resource.destroy
      respond_with resource
    end

  private

    def authorize!(action, object)
      raise AccessDenied unless allowance.can? action.to_sym, object
    end

    def collection
      instance_variable_get("@#{plural_resource_name}") || begin
        instance_variable_set("@#{plural_resource_name}",
          allowance.scoped_model(params[:action].to_sym, self.class.resource_class).scoped)
      end
    end

    def resource
      if params[:id]
        instance_variable_get("@#{singular_resource_name}") ||
          instance_variable_set("@#{singular_resource_name}", collection.send(self.class.resource_options[:finder], params[:id]))
      end
    end

    def allowance
    end

    def singular_resource_name
      self.class.resource_class.name.underscore
    end

    def plural_resource_name
      singular_resource_name.pluralize
    end
  end

  module ClassMethods
    def resource_class
      @resource_class
    end

    def resource_options
      @resource_options
    end
  end

  module ControllerMacro
    def serve_resource(opts = {})
      @resource_options = {
        finder: :find,
        class: name.gsub(/Controller$/, '').singularize.constantize
      }.merge(opts)

      include InstanceMethods
      extend ClassMethods

      @resource_class = @resource_options[:class]

      helper_method :resource, :collection

      before_filter(only: :index) do
        authorize! params[:action], self.class.resource_class
      end

      before_filter(except: :index) do
        authorize! params[:action], resource
      end
    end
  end
end

ActionController::Base.extend(Resourcery::ControllerMacro)
