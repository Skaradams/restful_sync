module RestfulSync
  class ApiNotifier
    require 'nestful'
    
    class << self
      def notify! action, object
        id = object.id if %(put delete).include? action.to_s 
        params = decorated(object).as_json.merge(model: object.class.to_s, authentication_token: RestfulSync.api_token)
        
        RestfulSync::ApiTarget.all.each do |target|
          if RestfulSync.sync_object? object, target
            Nestful.send(
              action, 
              endpoint_for(target, object, id), 
              params, 
              :format => Nestful::Formats::JsonFormat.new
            )
          end
        end    
      end

      def endpoint_for target, object, id=nil
        url_namespace = url_namespace_for object.class
        
        url = "#{ target.end_point }/#{url_namespace}"
        id ? "#{url}/#{id.to_s}" : url
      end

      def decorated object
        RestfulSync::BaseDecorator.decorate(object)
      end
    end
  end
end