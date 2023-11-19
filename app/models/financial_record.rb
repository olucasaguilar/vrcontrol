class FinancialRecord < ApplicationRecord  
  validates :tipo_movimento, :data_hora, presence: true
  validates :valor, numericality: { greater_than_or_equal_to: 1 }
end
