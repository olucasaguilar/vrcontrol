class FinancialGarmentReturnSale < ApplicationRecord
  belongs_to :registro_financeiro, class_name: 'FinancialRecord'
  belongs_to :peca_venda_retorno, class_name: 'GarmentSaleReturn'
end
