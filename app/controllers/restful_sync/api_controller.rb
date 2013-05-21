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
      @params = params["restful_sync"]  
      @model = @params.delete(:model).constantize
      @status = 404
      @response = {}
    end

    def authenticate
      raise ActiveRecord::RecordNotFound unless RestfulSync::ApiClient.find_by_authentication_token(@params.delete(:authentication_token))
    end

    def render_json
      render status: @status, json: @response.to_json
    end

    def create
      if (object = @model.create(@model.from_sync(@params))).valid?
        @status = 200    
      else
        @response = object.errors if object
      end

      render_json
    end
  
    def update
      # p @params
      # p @model.from_sync(@params)
      parameters = @model.from_sync(@params)
      object = @model.find(parameters.delete("id"))

      if object.update_attributes(parameters)
        @status = 200
      else
        @response = object.errors if object
      end
      
      render_json
    end
   
    def destroy
      object = RestfulSync::SyncRef.find_by_uuid(params["id"])

      if object && object.resource && object.resource.destroy
        @status = 200
      end
      @status = 200
      render_json
    end
  end
end
