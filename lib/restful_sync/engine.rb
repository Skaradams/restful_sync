module RestfulSync
  class Engine < ::Rails::Engine
    isolate_namespace RestfulSync

    # TODO : put referrable in lib, require file instead of 'if defined?'
    if defined? RestfulSync::Referrable
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, RestfulSync::Referrable)
      end
    end
  end
end
