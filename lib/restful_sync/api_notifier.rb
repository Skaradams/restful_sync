module RestfulSync
  require 'httparty'
  class ApiNotifier
    include HTTParty

    def post object
      notify! :post, object
    end

    def put object
      notify! :put, object, object.sync_ref.uuid
    end

    def delete object
      notify! :delete, object, object.sync_ref.uuid
    end


    def notify! action, object, id=nil
      params = object.to_sync.merge(model: object.class.to_s, authentication_token: RestfulSync.api_token)

      RestfulSync::ApiTarget.all.each do |target|
        self.class.send action, "#{endpoint_for(target, object, id)}", { base_uri: target.end_point, body: { restful_sync: params } }
      end
    end

    def endpoint_for target, object, id=nil
      url_namespace = url_namespace_for object.class
      endpoint = id ? "#{url_namespace}/#{id.to_s}" : url_namespace
      "/#{endpoint}"
    end
  end
end