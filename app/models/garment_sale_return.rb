class GarmentSaleReturn < ApplicationRecord
  belongs_to :vendedor, class_name: 'Entity', foreign_key: 'vendedor_id'
  validates :data_hora, presence: true
end
