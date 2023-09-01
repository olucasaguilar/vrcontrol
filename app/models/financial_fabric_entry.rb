class FinancialFabricEntry < ApplicationRecord
  belongs_to :registro_financeiro, class_name: 'FinancialRecord'
  belongs_to :entrada_tecido, class_name: 'FabricEntry'
end
