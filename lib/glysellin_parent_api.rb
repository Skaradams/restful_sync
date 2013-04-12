require "glysellin_parent_api/engine"

module GlysellinParentApi

  mattr_accessor :observed_resources
  @@observed_resources = []

  mattr_accessor :accessible_resources
  @@accessible_resources = []  

  mattr_accessor :end_point
  @@end_point = ""  

  def self.config
    yield self if block_given?
    GlysellinParentApi::ApiObserver.init_observable
  end
end

require "glysellin_parent_api/url_helper"
require "glysellin_parent_api/api_notifier"
require "glysellin_parent_api/api_observer"
