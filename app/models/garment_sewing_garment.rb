class GarmentSewingGarment < ApplicationRecord
  belongs_to :estoque_pecas, class_name: 'GarmentStock'
  belongs_to :saida_peca_estoque_costura, class_name: 'GarmentSewingStockExit'
end
