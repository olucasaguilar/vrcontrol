class FinancialScreensPrinting < ApplicationRecord
  belongs_to :registro_financeiro, class_name: 'FinancialRecord'
  belongs_to :peca_serigrafia, class_name: 'GarmentScreenPrinting'
end
