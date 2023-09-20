class FabricStockEntry < ApplicationRecord
  belongs_to :entrada_tecido, class_name: 'FabricEntry'
  belongs_to :estoque_tecido, class_name: 'FabricStock'

  validates :entrada_tecido, presence: true
  validates :estoque_tecido, presence: true, uniqueness: true
  validates :valor_tecido, presence: true, numericality: { greater_than: 0 }
end
