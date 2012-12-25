module Resourcery
  module Actions
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
  end
end
