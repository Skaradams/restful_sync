module GlysellinParentApi
  class ApiObserver < ActiveRecord::Observer
  
    class << self
      def init_observable
        observe GlysellinParentApi.observed_resources
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