module Resourcery
  module Helpers

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

    def parent_resource
      parent_resource_ivar || parent_resource_class.send(resource_options[:parent_finder], params[resource_options[:parent_id_param]])
    end

    def parent_resource_name
      resource_options[:parent].to_s
    end

    def parent_resource_class
      parent_resource_name.classify.constantize
    end

    def singular_resource_name
      resource_class.name.underscore
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

    def parent_resource_ivar
      instance_variable_get("@#{parent_resource_name}")
    end

    def parent_resource_ivar=(v)
      instance_variable_set("@#{parent_resource_name}", v)
    end

    def parent_resource_scope
      instance_variable_get("@#{resource_options[:parent]}").try(plural_resource_name)
    end
  end
end