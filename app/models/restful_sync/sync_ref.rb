module RestfulSync
  class SyncRef < ActiveRecord::Base
    attr_accessible :resource_id, :resource_type, :uuid
    belongs_to :resource, polymorphic: true
    validates_presence_of :resource_type, :uuid
    
    before_validation :generate_uuid

    def generate_uuid

      # Find a UUID generation gem
      token = SecureRandom.urlsafe_base64

      # while RestfulSync::SyncRef.where(uuid: token).exists? do
      #   token = SecureRandom.urlsafe_base64        
      # end

      self.uuid = token unless self.uuid
    end
  end    
end