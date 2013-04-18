module RestfulSync
  module NestedResourceHelper
    def process_nested_resource
      ids, data = parse_resource_hash params["api"]
      create_resource ids, data do
        resource = @model.where(id: params[:id]).first
        resource.destroy if resource
      end
    end

    protected

    def create_resource ids, data, &before_save
      model = @model.new
      data.each do |key, val|
        model.send("#{key}=", val)
      end
      
      if model.valid?
        set_ids model, ids
        before_save.call if block_given?
        model.save
      end
      model
    end

    def update_resource ids, data
      model = @model.find(params[:id]).destroy
      create_resource ids, data
    end

    def parse_resource_hash params
      ids, data = {}, {}

      params.each do |key, attr|
        key = key.to_s
        if key == "id"
          ids[key] = attr
        elsif attr.is_a? Hash
          ids[key.gsub(/_attributes$/, '')], data[key] = parse_resource_hash attr
        else
          data[key] = attr
        end    
      end

      [ids, data]
    end

    def set_ids model, ids
      models = model.is_a?(Array) ? model : [model]
      ids.each do |key, val|
        if key == "id"
          model.id = val
        elsif key.match(/^\d+$/)
          set_ids model[key.to_i], val
        else
          set_ids model.send(key), val
        end
      end
    end
  end
end