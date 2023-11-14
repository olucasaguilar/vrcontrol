class GarmentSaleStockExit < ApplicationRecord
  belongs_to :peca_venda_saida, class_name: 'GarmentSaleExit'
  belongs_to :estoque_pecas_acabadas, class_name: 'GarmentFinishedStock'
end
