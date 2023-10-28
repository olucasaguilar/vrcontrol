class GarmentScreenPrinting < ApplicationRecord
  belongs_to :serigrafia, class_name: 'Entity', foreign_key: 'serigrafia_id'
  validates :data_hora_ida, presence: true
end
