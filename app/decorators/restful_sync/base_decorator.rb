module RestfulSync
  require 'draper'
  class BaseDecorator < Draper::Decorator
    attr_accessor :has_many_attributes, :has_many_through_attributes
    
    def as_json
      
      attributes = source.attributes
      accessible = source.class.accessible_attributes + ["id"]
      attributes = attributes.as_json.keep_if { |key, value| accessible.include? key }
      
      nested_resources = source.class.reflect_on_all_associations

      nested_resources.each do |association|
        # Nested attributes
        if source.nested_attributes_options.keys.include? association.name
          if (associated = source.send(association.name))
            attributes["#{association.name}_attributes"] = {}
            # Has many
            if associated.is_a?(Array)
              associated.each_with_index do |associated_object, i|
                attributes["#{association.name}_attributes"][i.to_s] = self.class.decorate(associated_object).as_json
              end
            # Has one
            else
              obj = associated.is_a?(ActiveRecord::Relation) ? obj : self.class.decorate(associated)
              attributes["#{association.name}_attributes"] = obj.as_json
            end
          end

        # Array of ids
        else
          if [:has_many, :has_and_belongs_to_many].include? association.macro
            key = association.name.to_s.singularize
            attributes["#{key}_ids"] = []
            attributes["#{key}_ids"] = source.send(association.name).map { |obj| obj.id.to_s }
          # elsif association.macro == :has_one && source.send(association.name)
          #   key = association.name.to_s.singularize
          #   attributes[key] = source.send(association.name).id
          end
        end
      end

      attributes
    end
  end
end