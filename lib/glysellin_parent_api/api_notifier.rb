module GlysellinParentApi
  class ApiNotifier
    require 'nestful'
    
    class << self
      def notify! action, object
        id = object.id if %(put delete).include? action.to_s 

        Nestful.send(action, endpoint_for(object, id), decorated(object).as_json, :format => Nestful::Formats::JsonFormat.new)    
      end

      # TODO : base url from configs
      def endpoint_for object, id=nil
        url_namespace = url_namespace_for object.class
        
        url = "#{ GlysellinParentApi.end_point }/#{url_namespace}"
        id ? "#{url}/#{id.to_s}" : url
      end

      def decorated object
        Glysellin::BaseDecorator.decorate(object)
      end
    end
  end
end