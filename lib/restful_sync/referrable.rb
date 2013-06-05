module RestfulSync
  module Referrable
    extend ActiveSupport::Concern

    included do
      def self.inherited(klass)
        unless klass.name == "RestfulSync::SyncRef"
          klass.attr_accessible :sync_ref_attributes
          klass.has_one :sync_ref, class_name: "RestfulSync::SyncRef", as: :resource, dependent: :destroy
          klass.accepts_nested_attributes_for :sync_ref
          
          klass.before_validation :ensure_ref
        end
      end
    end

    def ensure_ref
      # self.sync_ref = RestfulSync::SyncRef.new unless self.sync_ref
      self.build_sync_ref unless sync_ref
    end

    # Called from : BaseDecorator#as_json
    def to_sync parent_class = ""
      nested_associations = self.nested_attributes_options.keys
      accessible = self.class.syncable_attributes
      
      attributes = self.attributes.as_json.keep_if { |key, value| accessible.include? key.to_sym }
    
      associations = self.class.reflect_on_all_associations

      associations.each do |association|
        klass = association.class_name
        object = self.send(association.name)
        
        if object.present?
          if nested_associations.include?(association.name)
            nested_key = "#{ association.name }_attributes"
            
            attributes[nested_key] = association.collection? ? object.map { |obj| obj.to_sync self.class.to_s } : object.to_sync(self.class.to_s)
          else
            unless self.class.name == "RestfulSync::SyncRef"
              if association.macro == :has_many
                uuid_str = "uuids"
                id_str = "ids"
              else
                uuid_str = "uuid"
                id_str = "id"
              end
              
              uuid_key = "#{association.name.to_s.singularize}_#{uuid_str}"
              id_key = "#{association.name.to_s.singularize}_#{id_str}"

              attributes.delete(id_key)

              # Don't include id if association is parent in tree
              unless parent_class.include? association.class_name
                attributes[uuid_key] = association.collection? ? object.map { |obj| obj.sync_ref.uuid } : object.sync_ref.uuid
              end
            end
          end
        end
      end

      attributes
    end
    
    # Arguments possibles :
    #
    # [{ resource_id: X, resource_type: "xxx" }, { resource_id: X, resource_type: "xxx" }]
    # { resource_id: X, resource_type: "xxx" }
    #
    # Pour optimiser ici, dans la migration :
    # add_index :sync_refs, [:resource_id, :resource_type]
    #
    def uuid_from id, type
      RestfulSync::SyncRef.where(resource_id: id, resource_type: type).pluck(:uuid).first
    end
    
   
    module ClassMethods
      # Product :: { uuid: "aa-aaa", name: "xx", taxonomy_uuids: ["aaaa", "bbbb"] } 
      #
      def from_sync tree
        tree = tree.reduce({}) do |hash, pair|
          key, value = pair

          if key.match(/\w+uuid(s?)$/)
            new_key = key.gsub(/uuid(s?)$/, 'id\1')

            ids = ids_from_uuids(value)
            hash[new_key] = ids if ids 
          elsif value.is_a? Hash
            hash[key] = from_sync(value)
          elsif value.is_a? Array
            hash[key] = value.map { |val| from_sync(val) }
          else
            hash[key] = value
          end
          hash
        end

        if tree["sync_ref_attributes"]
          object = RestfulSync::SyncRef.find_by_uuid tree["sync_ref_attributes"]["uuid"]
          if object
            tree["id"] = object.resource_id 
            tree.delete('sync_ref_attributes')
          end
        end
        tree
      end
      
      def ids_from_uuids uuids
        ids = RestfulSync::SyncRef.where(uuid: uuids).pluck(:resource_id)
        uuids.is_a?(Array) ? ids : ids.first
      end

      def syncable_attributes= attributes
        @syncable_attributes = attributes
      end

      def syncable_attributes
        @syncable_attributes || accessible_attributes
      end
    end 
  end
end