class FinancialRecord < ApplicationRecord
  before_save :calculate_and_set_saldo
  
  validates :valor, :tipo_movimento, :data_hora, presence: true
  
  private

  def calculate_and_set_saldo
    last_record_saldo = 0
    if FinancialRecord.count > 0
      last_record_saldo = FinancialRecord.last.saldo
    end
    
    if self.tipo_movimento == 'Entrada'
      self.saldo = last_record_saldo + self.valor
    else
      self.saldo = last_record_saldo - self.valor
    end    
  end
end
