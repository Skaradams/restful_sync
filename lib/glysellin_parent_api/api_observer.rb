module Glysellin
  class ApiObserver < ActiveRecord::Observer
    class << self
      attr_accessor :observed_class

      def register klass, observed_class
        # Glysellin.observers << klass
        observe observed_class
        @observed_class = observed_class
      end
    end

    def after_create object
      ApiNotifier.notify!(:post, object)
    end

    def after_update object
      ApiNotifier.notify!(:put, object)
    end

    def after_destroy object
      ApiNotifier.notify!(:delete, object)
    end
  end
end