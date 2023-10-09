class FinancialFabricCut < ApplicationRecord
  belongs_to :registro_financeiro, class_name: 'FinancialRecord'
  belongs_to :tecido_corte, class_name: 'FabricCut'
end
