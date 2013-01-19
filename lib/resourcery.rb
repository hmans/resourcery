require 'resourcery/version'
require 'resourcery/base'
require 'resourcery/allowance'

module Resourcery
  class Unauthorized < StandardError ; end

  RESOURCE_ACTIONS     = [:show, :edit, :update, :destroy]
  COLLECTION_ACTIONS   = [:index]
  NEW_RESOURCE_ACTIONS = [:new, :create]
end
