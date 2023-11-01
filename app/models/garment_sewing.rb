class GarmentSewing < ApplicationRecord
  belongs_to :costureira, class_name: 'Entity', foreign_key: 'costureira_id'
  validates :data_hora_ida, presence: true
end
