module Resourcery
  module ControllerExtensions
    module Filters
      def self.included(base)
        # Load parent resource before all actions.
        #
        base.before_filter do
          opts = self.class.resource_options
          if opts[:parent] && params[opts[:parent_id_param]]
            instance_variable_set("@#{opts[:parent]}", opts[:parent].to_s.classify.constantize.send(opts[:parent_finder], params[opts[:parent_id_param]]))
          end
        end

        base.before_filter(only: :index) do
          self.collection_ivar = collection
        end

        base.before_filter(only: [:show, :edit, :update, :destroy]) do
          self.resource_ivar = resource
        end

        base.before_filter(only: [:new, :create]) do
          self.resource_ivar = new_resource
        end
      end
    end

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
        respond_with resource_ivar
      end

      def create
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

      def resource_options
        self.class.resource_options
      end

      # The starting point. Override this in a controller if necessary.
      #
      def resource_base
        parent_resource_scope || resource_class.scoped
      end

      def collection
        collection_ivar || resource_base
      end

      def resource
        resource_ivar || resource_base.send(resource_options[:finder], params[:id])
      end

      def new_resource
        resource_ivar || resource_base.new(params[singular_resource_name])
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

      def parent_resource_scope
        instance_variable_get("@#{resource_options[:parent]}").try(plural_resource_name)
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
