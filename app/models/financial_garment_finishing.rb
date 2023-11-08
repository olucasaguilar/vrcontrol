class FinancialGarmentFinishing < ApplicationRecord
  belongs_to :registro_financeiro, class_name: 'FinancialRecord'
  belongs_to :peca_acabamento, class_name: 'GarmentFinishing'
end
