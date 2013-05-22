module RestfulSync
  class Engine < ::Rails::Engine
    isolate_namespace RestfulSync

    ActiveSupport.on_load :active_record do
      ActiveRecord::Base.send(:include, RestfulSync::Referrable)
    end
  end
end
