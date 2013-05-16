module RestfulSync
  module Referrable
    extend ActiveSupport::Concern

    included do
      def self.inherited(klass)
        unless klass.name == "RestfulSync::SyncRef"
          klass.attr_accessible :sync_ref_attributes
          klass.has_one :sync_ref, class_name: "RestfulSync::SyncRef", as: :resource
          klass.accepts_nested_attributes_for :sync_ref
          
          # Problems with referrable included in sync_ref
          # validates_presence_of :sync_ref
          
          klass.before_validation :ensure_ref
        end
      end
    end
    
    def ensure_ref
      self.sync_ref = RestfulSync::SyncRef.new unless self.sync_ref

      # self.build_sync_ref unless sync_ref
    end

    # Called from : BaseDecorator#as_json
    def to_sync
      # Remplacer TOUS les ids par (_id, _ids)
      # Has many et Has one
      nested_associations = self.nested_attributes_options.keys
      accessible = self.class.accessible_attributes

      attributes = self.attributes.as_json.keep_if { |key, value| accessible.include? key }

      associations = self.class.reflect_on_all_associations

      # p "---------------------------------"
      # p self
      # p associations.map(&:name)

      associations.each do |association|
        klass = association.class_name
        object = self.send(association.name)
        
        # apply = ->(&block) { 
        #   association.collection? ? 
        #     object.map(&block) : block.call
        # }
        
        # p "**********************************"
        # p association.name
        
        if object.present?
          if nested_associations.include?(association.name)
            nested_key = "#{ association.name }_attributes"
        
            # p "nested_key"
            # p nested_key
            # p object
            
            attributes[nested_key] = association.collection? ? object.map(&:to_sync) : object.to_sync 
          else
            
            # uuid_key = key.gsub(/id(s?)/, 'uuid\1')

            # TODO : dynamic key (uuid ou uuids)
            # p key

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
              # p uuid_key
              # p "uuid"
              # p uuid_key
              attributes.delete(id_key)
              attributes[uuid_key] = association.collection? ? object.map { |obj| uuid_from(obj.id, klass) } : uuid_from(object.id, klass)
              # apply.call { |obj| uuid_from(obj.id, klass) }
            end
          end
        end
      end
      # p "/////////////////////////////"
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

            hash[new_key] = ids_from_uuids(value)
          elsif value.is_a? Hash
            hash[key] = from_sync(value)
          elsif value.is_a? Array
            hash[key] = value.map { |val| from_sync(val) }
          else
            hash[key] = value
          end
          hash
        end
        p "////////////////"
        p tree
        if tree["sync_ref_attributes"]
          uuid = tree["sync_ref_attributes"]["uuid"]
          
          if (ref = SyncRef.find_by_uuid(uuid))
            tree["id"] = ref.resource_id
          end
        end
        tree    
      end
      
      def ids_from_uuids uuids
        ids = RestfulSync::SyncRef.where(uuid: uuids).pluck(:resource_id)
        uuids.is_a?(Array) ? ids : ids.first
      end
    end 
  end
end