module Resourcery
  module ControllerMacro
    def serve_resource(klass = nil, opts = {})
      @resource_options = {
        finder: :find
      }.merge(opts)

      extend  ControllerExtensions::ClassMethods
      include ControllerExtensions::Filters
      include ControllerExtensions::InstanceMethods

      # determine resource class
      @resource_class = case klass
        when Class then klass
        when Symbol then klass.to_s.classify.constantize
        else name.gsub(/Controller$/, '').singularize.constantize
      end

      helper_method :resource, :collection
    end
  end
end
