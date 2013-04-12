module RestfulSync
  module UrlHelper
    def url_namespace_for model_class
      model_class.to_s.underscore.pluralize
    end
  end
end
