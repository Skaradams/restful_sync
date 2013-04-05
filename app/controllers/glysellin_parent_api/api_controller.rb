require_dependency "glysellin_child_api/application_controller"

module GlysellinChildApi
  class ApiController < ApplicationController
    before_filter :init
    
    def init
      @status = 500
      @response = {}
    end

    def render_json
      render status: @status, json: @response.to_json
    end

    def create
      object = @model.new(JSON.parse(params[:attributes]))
      if object.save
        @status = 200
      else
        @response = object.errors if object
      end
      render_json
    end
  
    def update
      attributes = JSON.parse(params[:attributes])
      begin
        object = @model.update(attributes.delete("id"), attributes)
        if !object.valid?
          @response = object.errors 
        else
          @status = 200
        end
      rescue ActiveRecord::RecordNotFound
        @response = {message: "record not found"}
      end
      render_json
    end
  
    def destroy
      attributes = JSON.parse(params[:attributes])
      begin
        attributes["id"] && @model.destroy(attributes["id"])
        @status = 200
      rescue ActiveRecord::RecordNotFound
        @response = {message: "record not found"}
      end
      render_json
    end
  end
end
