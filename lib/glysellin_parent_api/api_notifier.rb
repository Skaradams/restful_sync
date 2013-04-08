module Glysellin
  class ApiNotifier
    require 'nestful'

    class << self
      def notify! action, object
        Nestful.send(action, endpoint_for(object), :format => :form)    
      end

      # TODO : base url from configs
      def endpoint_for object, params = nil
        params ||= object.attributes.to_json
        url_namespace = url_namespace_for object.class

        URI.encode "localhost:3000/api/#{url_namespace}/#{params}"
      end

      # Url namespace is "products" for table "glysellin_products"
      def url_namespace_for model_class
        model_class.table_name.gsub('glysellin_', '')
      end
    end
  end
end