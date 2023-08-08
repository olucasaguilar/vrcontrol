class Entity < ApplicationRecord
  belongs_to :entity_type, foreign_key: 'entity_types_id'
end
