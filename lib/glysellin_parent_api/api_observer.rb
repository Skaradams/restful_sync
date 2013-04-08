module Glysellin
  class ApiObserver < ActiveRecord::Observer
    class << self
      attr_accessor :observed_class

      def register klass, observed_class
        # Glysellin.observers << klass
        p "registered #{klass}"
        add_observer! klass
        observe observed_class
        @observed_class = observed_class
      end
    end

    def after_create object
      params = attributes_to_params object
      ApiNotifier.notify!(:create, object, params)
    end

    def after_update object
      params = attributes_to_params object
      ApiNotifier.notify!(:update, object, params)
    end

    def after_destroy object
      ApiNotifier.notify!(:destroy, object, object.attributes.select { |key, val| key == "id" })
    end
  end
end