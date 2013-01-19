module Resourcery
  module Base
    def self.included(base)
      base.class_eval do
        respond_to :html if mimes_for_respond_to.empty?

        before_filter only: RESOURCE_ACTIONS do
          authorize!(resource)
        end

        before_filter only: COLLECTION_ACTIONS do
          authorize!(collection)
        end

        before_filter only: NEW_RESOURCE_ACTIONS do
          authorize!(new_resource)
        end

        before_filter do
          instance_variable_set("@#{resource_name}", @resource)
          instance_variable_set("@#{resource_name.pluralize}", @collection)
        end

        helper_method :resource, :collection
      end
    end

    #
    # Actions
    #

    def index(&blk)
      respond_with collection, &blk
    end

    def show(&blk)
      respond_with resource, &blk
    end

    def edit(&blk)
      respond_with resource, &blk
    end

    def update(&blk)
      resource.update_attributes(params[resource_name])
      respond_with resource, &blk
    end

    def new(&blk)
      respond_with resource, &blk
    end

    def create(&blk)
      resource.save
      respond_with resource, &blk
    end

    def destroy(&blk)
      resource.destroy

      respond_with(resource) do |format|
        yield(format) if block_given?
        format.html { redirect_to(resource.class) }
      end
    end

  protected

    def resource_base
      self.class.name.gsub(/Controller$/, '').singularize.constantize
    end

    def resource_name
      resource_base.name.underscore.singularize
    end

    def resource_key
      :id
    end

    def collection
      @collection ||= resource_base.scoped
    end

    def resource
      @resource ||= resource_base.where(resource_key => params[:id]).first!
    end

    def new_resource
      @resource ||= collection.new(params[resource_name])
    end

    def authorize!(object)
      # overload this.
    end
  end
end
