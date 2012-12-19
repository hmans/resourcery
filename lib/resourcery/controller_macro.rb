module Resourcery
  module ControllerMacro
    def serve_resource(klass = nil, opts = {})
      @resource_options = {
        finder: :find,
        klass: klass || name.gsub(/Controller$/, '').singularize.constantize
      }.merge(opts)

      extend  ControllerExtensions::ClassMethods
      include ControllerExtensions::InstanceMethods

      @resource_class = @resource_options[:klass]

      helper_method :resource, :collection
    end
  end
end
