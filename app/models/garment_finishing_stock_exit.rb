class GarmentFinishingStockExit < ApplicationRecord
  belongs_to :peca_acabamento, class_name: 'GarmentFinishing'
  belongs_to :estoque_peca, class_name: 'GarmentStock'
end
