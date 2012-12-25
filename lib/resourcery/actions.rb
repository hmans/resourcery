module Resourcery
  module Actions
    def index
      respond_with collection
    end

    def show(&blk)
      respond_with resource, &blk
    end

    def edit(&blk)
      respond_with resource, &blk
    end

    def update(&blk)
      resource.update_attributes(params[singular_resource_name])
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
        format.html { redirect_to(resource_class) }
      end
    end
  end
end
