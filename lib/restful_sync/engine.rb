module RestfulSync
  class Engine < ::Rails::Engine
    isolate_namespace RestfulSync

    initializer "add referrable module" do
      # RestfulSync.accessible_resources.each { |model| model.send(:include, Referrable) }
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, RestfulSync::Referrable)
      end
    end
  end
end
