module RestfulSync
  class ApiObserver < ActiveRecord::Observer
  
    class << self
      def init_observable
        observe RestfulSync.observed_resources
      end
    end
    
    def after_create object
      RestfulSync::ApiTarget.all.each do |target|
        ApiNotifier.notify!(:post, object, target)
      end
    end

    def after_update object
      RestfulSync::ApiTarget.all.each do |target|
        ApiNotifier.notify!(:put, object, target)
      end
    end

    def after_destroy object
      RestfulSync::ApiTarget.all.each do |target|
        ApiNotifier.notify!(:delete, object, target)
      end
    end
  end
end