class Entity < ApplicationRecord
  belongs_to :entity_type, foreign_key: 'entity_types_id'
  validates :nome, presence: true, uniqueness: true
  validates :entity_types_id, presence: true

  has_many :fabric_entries
end
