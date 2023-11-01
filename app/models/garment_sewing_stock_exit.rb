class GarmentSewingStockExit < ApplicationRecord
  belongs_to :peca_costura, class_name: 'GarmentSewing'
  belongs_to :estoque_peca, class_name: 'GarmentStock'
end
