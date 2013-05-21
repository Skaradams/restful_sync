module RestfulSync
  class SyncRef < ActiveRecord::Base
    attr_accessible :resource_id, :resource_type, :uuid
    belongs_to :resource, polymorphic: true
    validates_presence_of :resource_type, :uuid

    before_validation :generate_uuid

    def generate_uuid
      self.uuid = SecureRandom.uuid unless uuid
    end

    def to_sync
      { uuid: uuid }
    end
  end    
end