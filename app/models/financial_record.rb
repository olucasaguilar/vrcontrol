class FinancialRecord < ApplicationRecord
  before_destroy :create_reverse_entry, unless: :skip_correction?
  before_save :calculate_and_set_saldo
  
  validates :tipo_movimento, :data_hora, presence: true
  validates :valor, numericality: { greater_than_or_equal_to: 1 }

  attr_accessor :skip_correction
  
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

  def create_reverse_entry
    return if skip_correction?

    new_entry = self.dup
    new_entry.tipo_movimento = self.tipo_movimento == 'Entrada' ? 'Saída' : 'Entrada'
    new_entry.valor = self.valor
    new_entry.saldo = self.tipo_movimento == 'Entrada' ? self.saldo - self.valor : self.saldo + self.valor
    new_entry.observacao = "Correção após exclusão"
    new_entry.save
  end

  def skip_correction?
    skip_correction
  end
end
