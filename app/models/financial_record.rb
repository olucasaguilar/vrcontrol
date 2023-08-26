class FinancialRecord < ApplicationRecord
  validates :valor, :saldo, :tipo_movimento, :data_hora, presence: true
end
