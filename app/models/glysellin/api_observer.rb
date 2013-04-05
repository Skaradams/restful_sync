module Glysellin
  class ApiObserver < ActiveRecord::Observer
    class << self
      attr_accessor :observed_class

      def register klass, observed_class
        Glysellin.observers << klass
        observe observed_class
        @observed_class = observed_class
      end
    end

    def after_create object
      ApiNotifier.notify!(:create, object)
    end

    def after_update object
      ApiNotifier.notify!(:update, object)
    end

    def after_destroy object
      ApiNotifier.notify!(:destroy, object)
    end
  end
end