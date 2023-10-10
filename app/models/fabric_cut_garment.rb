class FabricCutGarment < ApplicationRecord
  belongs_to :estoque_pecas, class_name: 'GarmentStock'
  belongs_to :saida_tecido_estoque, class_name: 'FabricStockEntry'
end
