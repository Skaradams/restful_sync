require_dependency "glysellin_parent_api/application_controller"

module GlysellinParentApi
  class UsersController < ApplicationController
    def init
      super
      @model = User
    end
  end
end
