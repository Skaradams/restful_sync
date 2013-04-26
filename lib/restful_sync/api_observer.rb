module RestfulSync
  class ApiObserver < ActiveRecord::Observer
  
    class << self
      def init_observable
        observe RestfulSync.observed_resources
      end
    end
    
    def after_create object
      RestfulSync::ApiSource.all.each do |source|
        ApiNotifier.notify!(:post, object, source)
      end
    end

    def after_update object
      RestfulSync::ApiSource.all.each do |source|
        ApiNotifier.notify!(:put, object, source)
      end
    end

    def after_destroy object
      RestfulSync::ApiSource.all.each do |source|
        ApiNotifier.notify!(:delete, object, source)
      end
    end
  end
end