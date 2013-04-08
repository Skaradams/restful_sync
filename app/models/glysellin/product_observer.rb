module Glysellin
  class ProductObserver < ApiObserver
    register self, Glysellin::Product
    
    def attributes_to_params object
      object.attributes.delete_if { |key, val| %w(created_at updated_at).include? key }
    end
  end
end