module GlysellinParentApi
  module UrlHelper
    # Url namespace is "products" for table "glysellin_products"
    def url_namespace_for model_class
      model_class.to_s.underscore.pluralize
    end
  end
end
