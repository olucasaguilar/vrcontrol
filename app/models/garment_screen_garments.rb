class GarmentScreenGarment < ApplicationRecord
  belongs_to :estoque_pecas, class_name: 'GarmentStock'
  belongs_to :saida_peca_serigrafia, class_name: 'GarmentScreenPrintingStockExit'
end
