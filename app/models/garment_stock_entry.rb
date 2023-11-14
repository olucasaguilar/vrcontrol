class GarmentStockEntry < ApplicationRecord
  belongs_to :saida_peca_acabada, class_name: 'GarmentFinishedStock'
  belongs_to :peca_venda_retorno, class_name: 'GarmentSaleReturn'
end
