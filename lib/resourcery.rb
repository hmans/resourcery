require 'resourcery/controller_extensions'
require 'resourcery/controller_macro'

module Resourcery
  class AccessDenied < StandardError ; end
end

ActionController::Base.extend(Resourcery::ControllerMacro)
