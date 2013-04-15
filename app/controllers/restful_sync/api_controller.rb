module RestfulSync
  class ApiController < ApplicationController
    include NestedResourceHelper
    include UrlHelper
    before_filter :init

    rescue_from ActiveRecord::RecordNotFound do
      @response = {message: "record not found"}
      render_json
    end

    def init
      @model = model_const_from request.path
      @status = 404
      @response = {}
    end

    def render_json
      render status: @status, json: @response.to_json
    end

    def create
      if (object = process_nested_resource).valid?
        @status = 200
      else
        @response = object.errors 
      end

      render_json
    end
  
    def update
      if (object = process_nested_resource).valid?
        @status = 200
      else
        @response = object.errors 
      end
      
      render_json
    end
  
    def destroy
      @model.destroy(params[:id].to_i)
      @status = 200
      
      render_json
    end

    protected

    def model_const_from path
      path = path.split('/').drop(2)
      path.pop if path.last.match(/^[0-9]+$/)
      path.join('/').singularize.camelize.constantize
    end
  end
end
