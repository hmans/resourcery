require 'resourcery/filters'
require 'resourcery/helpers'
require 'resourcery/actions'
require 'resourcery/controller_macro'

module Resourcery
  class AccessDenied < StandardError ; end
end

ActionController::Base.extend(Resourcery::ControllerMacro)
