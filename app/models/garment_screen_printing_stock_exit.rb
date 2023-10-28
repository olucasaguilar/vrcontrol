class GarmentScreenPrintingStockExit < ApplicationRecord
  belongs_to :peca_serigrafia, class_name: 'GarmentScreenPrinting'
  belongs_to :estoque_peca, class_name: 'GarmentStock'
end
