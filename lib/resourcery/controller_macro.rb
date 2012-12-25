module Resourcery
  module ControllerMacro
    def serve_resource(klass = nil, opts = {})
      opts = {
        finder: :find
      }.merge(opts)

      # set up loading of parent resource
      if opts[:parent]
        opts[:parent_id_param] ||= "#{opts[:parent]}_id"
        opts[:parent_finder]   ||= :find
      end

      # store options
      @resource_options = opts

      # load controller extensions
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

      # Make sure we'll serve at least HTML
      respond_to :html if mimes_for_respond_to.empty?
    end
  end
end
