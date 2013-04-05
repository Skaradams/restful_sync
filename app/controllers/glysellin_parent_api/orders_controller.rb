require_dependency "glysellin_parent_api/application_controller"

module GlysellinParentApi
  class OrdersController < ApplicationController
    def init
      super
      @model = Glysellin::Order
    end
  end
end
