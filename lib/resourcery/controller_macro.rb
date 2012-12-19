module Resourcery
  module ControllerMacro
    def serve_resource(opts = {})
      @resource_options = {
        finder: :find,
        class: name.gsub(/Controller$/, '').singularize.constantize
      }.merge(opts)

      extend  ControllerExtensions::ClassMethods
      include ControllerExtensions::InstanceMethods

      @resource_class = @resource_options[:class]

      helper_method :resource, :collection
    end
  end
end
