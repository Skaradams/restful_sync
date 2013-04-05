module Glysellin
  class ApiNotifier
    require 'nestful'

    class << self
      def notify! action, object
        Nestful.send(action, endpoint_for(object), :format => :form)    
      end

      # TODO : base url from configs
      def endpoint_for object
        param = object.attributes.to_json
        URI.encode "localhost:3000/api/#{object.class.table_name}/#{param}"
      end
    end
  end
end