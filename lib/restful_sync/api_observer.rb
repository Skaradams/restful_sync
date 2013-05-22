module RestfulSync
  class ApiObserver < ActiveRecord::Observer
  
    class << self
      def init_observable
        observe RestfulSync.observed_resources
      end
    end
    
    def after_create object
      ApiNotifier.new().post object
    end

    def after_update object
      ApiNotifier.new().put object
    end

    def after_destroy object
      ApiNotifier.new().delete object
    end
  end
end