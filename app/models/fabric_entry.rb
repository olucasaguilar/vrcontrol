class FabricEntry < ApplicationRecord
  belongs_to :entity

  validates :data_hora, presence: true
end
