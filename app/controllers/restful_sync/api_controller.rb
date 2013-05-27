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
      params["restful_sync"]
      @model = params["restful_sync"].delete(:model).constantize
      @status = 404
      @response = {}
    end

    def authenticate
      raise ActiveRecord::RecordNotFound unless RestfulSync::ApiClient.find_by_authentication_token(params["restful_sync"].delete(:authentication_token))
    end

    def render_json
      render status: @status, json: @response.to_json
    end

    def create
      if (object = @model.create(@model.from_sync(params["restful_sync"]))).valid?
        @status = 200    
      else
        @response = object.errors if object
      end

      render_json
    end
  
    def update
      parameters = @model.from_sync(params["restful_sync"])
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
      render_json
    end
  end
end
