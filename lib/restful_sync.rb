module RestfulSync

  mattr_accessor :observed_resources
  @@observed_resources = []

  mattr_accessor :accessible_resources
  @@accessible_resources = []  

  mattr_accessor :api_token
  @@api_token = ""

  mattr_accessor :override_api_controller
  @@override_api_controller = []

  mattr_accessor :sync_filter
  @@sync_filter = nil

  def self.config
    yield self if block_given?
    RestfulSync::ApiObserver.init_observable
  end

  def self.sync_object? object, target
    if @@sync_filter
      @@sync_filter.call(object, target)
    else
      true
    end
  end
end

require "restful_sync/url_helper"
require "restful_sync/api_notifier"
require "restful_sync/api_observer"
require "restful_sync/engine"