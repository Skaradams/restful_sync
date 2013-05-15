module RestfulSync
  class ApiObserver < ActiveRecord::Observer
  
    class << self
      def init_observable
        observe RestfulSync.observed_resources
      end
    end
    
    def after_create object
      p "CREATE"
      ApiNotifier.notify!(:post, object)
    end

    def after_update object
      p "UPDATE"
      ApiNotifier.notify!(:put, object)
    end

    def after_destroy object
      ApiNotifier.notify!(:delete, object)
    end
  end
end