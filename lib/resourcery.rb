module Resourcery
  class Unauthorized < StandardError ; end

  RESOURCE_ACTIONS     = [:show, :edit, :update, :destroy]
  COLLECTION_ACTIONS   = [:index]
  NEW_RESOURCE_ACTIONS = [:new, :create]

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
    @collection ||= begin
      if Resourcery.allowance_enabled?
        resource_base.allowed(current_user, action_name.to_sym)
      else
        resource_base.scoped
      end
    end
  end

  def resource
    @resource ||= resource_base.where(resource_key => params[:id]).first!
  end

  def new_resource
    @resource ||= collection.new(params[resource_name])
  end

  def authorize!(object)
    return unless Resourcery.allowance_enabled?

    # check resource scopes
    if object.respond_to?(:model_name)
      # object is a collection
      raise Unauthorized unless current_user.allowed?(action_name.to_sym, object.model_name.constantize)
      raise Unauthorized unless object == collection
    else
      # object is a resource
      if object.new_record?
        # TODO: how do we authorize a new record?
      else
        raise Unauthorized unless current_user.allowed?(action_name.to_sym, object)
      end
    end
  end

  class << self
    def allowance_enabled?
      defined?(Allowance)
    end
  end
end
