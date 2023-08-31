class FabricEntry < ApplicationRecord
  belongs_to :entity

  validates :entity_id, :data_hora, presence: true
end
