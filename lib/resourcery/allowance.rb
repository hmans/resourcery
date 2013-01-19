module Resourcery
  module Allowance
    def collection
      super.allowed(current_user, action_name.to_sym)
    end

    def authorize!(object)
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
  end
end
