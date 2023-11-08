class GarmentFinishing < ApplicationRecord
  belongs_to :acabamento, class_name: 'Entity', foreign_key: 'acabamento_id'
  validates :data_hora_ida, presence: true
end
