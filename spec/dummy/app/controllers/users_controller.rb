class UsersController < ApplicationController
  serve_resource

  def allowance
    @allowance ||= Allowance.define do |a|
      a.allow! :manage, User
    end
  end
end
