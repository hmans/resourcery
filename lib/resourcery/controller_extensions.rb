module Resourcery
  module ControllerExtensions
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
        self.resource_ivar = collection.new(params[singular_resource_name])
        respond_with resource_ivar
      end

      def create
        self.resource_ivar = collection.new(params[singular_resource_name])
        resource.save
        respond_with resource
      end

      def destroy
        resource.destroy
        redirect_to resource_class
      end

    protected

      def resource_class
        self.class.resource_class
      end

      # The starting point. Override this in a controller if necessary.
      #
      def resource_base
        resource_class.scoped
      end

      def collection
        self.collection_ivar ||= resource_base
      end

      def resource
        self.resource_ivar ||= begin
          if params[:id]
            collection.send(self.class.resource_options[:finder], params[:id])
          end
        end
      end

      def singular_resource_name
        self.class.resource_class.name.underscore
      end

      def plural_resource_name
        singular_resource_name.pluralize
      end

      def resource_ivar
        instance_variable_get("@#{singular_resource_name}")
      end

      def resource_ivar=(v)
        instance_variable_set("@#{singular_resource_name}", v)
      end

      def collection_ivar
        instance_variable_get("@#{plural_resource_name}")
      end

      def collection_ivar=(v)
        instance_variable_set("@#{plural_resource_name}", v)
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
  end
end
