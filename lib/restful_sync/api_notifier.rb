module RestfulSync
  class ApiNotifier
    require 'nestful'
    
    class << self
      def notify! action, object
        id = object.id if %(put delete).include? action.to_s 
        Nestful.send(
          action, 
          endpoint_for(object, id), 
          # TODO : token from configs
          decorated(object).as_json.merge(model: object.class.to_s, authentication_token: RestfulSync.api_token), 
          :format => Nestful::Formats::JsonFormat.new
        )    
      end

      def endpoint_for object, id=nil
        url_namespace = url_namespace_for object.class
        
        url = "#{ RestfulSync.end_point }/#{url_namespace}"
        id ? "#{url}/#{id.to_s}" : url
      end

      def decorated object
        RestfulSync::BaseDecorator.decorate(object)
      end
    end
  end
end