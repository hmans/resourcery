module Resourcery
  module Filters
    def self.included(base)
      # Load parent resource before all actions.
      #
      base.before_filter do
        if resource_options[:parent] && params[resource_options[:parent_id_param]]
          self.parent_resource_ivar = parent_resource
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
end
