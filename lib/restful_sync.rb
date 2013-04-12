module RestfulSync

  mattr_accessor :observed_resources
  @@observed_resources = []

  mattr_accessor :accessible_resources
  @@accessible_resources = []  

  mattr_accessor :end_point
  @@end_point = ""  

  def self.config
    yield self if block_given?
    RestfulSync::ApiObserver.init_observable
  end
end

require "restful_sync/url_helper"
require "restful_sync/api_notifier"
require "restful_sync/api_observer"
require "restful_sync/engine"