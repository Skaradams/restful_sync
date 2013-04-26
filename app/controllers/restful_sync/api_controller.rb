module RestfulSync
  class ApiController < ApplicationController
    include NestedResourceHelper
    include UrlHelper
    before_filter :init, :authenticate

    rescue_from ActiveRecord::RecordNotFound do
      @response = {message: "record not found"}
      render_json
    end

    def init
      @model = params["api"].delete(:model).constantize
      @status = 404
      @response = {}
    end

    def authenticate
      raise ActiveRecord::RecordNotFound unless RestfulSync::ApiSource.find_by_authentication_token(params["api"].delete(:authentication_token))
    end

    def render_json
      render status: @status, json: @response.to_json
    end

    def create
      if (object = process_nested_resource).valid?
        @status = 200
      else
        @response = object.errors if object
      end

      render_json
    end
  
    def update
      if (object = process_nested_resource).valid?
        @status = 200
      else
        @response = object.errors if object
      end
      
      render_json
    end
  
    def destroy
      @model.destroy(params[:id].to_i)
      @status = 200
      
      render_json
    end

  end
end
