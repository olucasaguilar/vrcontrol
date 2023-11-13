class GarmentFinishingGarment < ApplicationRecord
  belongs_to :estoque_pecas_acabada, class_name: 'GarmentFinishedStock'
  belongs_to :saida_peca_estoque, class_name: 'GarmentFinishingStockExit'
end
