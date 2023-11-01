class FinancialGarmentSewing < ApplicationRecord
  belongs_to :registro_financeiro, class_name: 'FinancialRecord'
  belongs_to :peca_costura, class_name: 'GarmentSewing'
end
