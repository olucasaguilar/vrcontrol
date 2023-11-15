class GarmentFinishedStock < ApplicationRecord
  before_save :calculate_and_set_saldo

  belongs_to :tipo_peca, class_name: 'GarmentType'

  validates :tipo_movimento, :data_hora, presence: true
  validates :quantidade, numericality: { greater_than_or_equal_to: 1 }

  validate :saldo_nao_negativo
  
  private

  def calculate_and_set_saldo
    last_record_saldo = 0
    if GarmentFinishedStock.any? && GarmentFinishedStock.where(tipo_peca_id: self.tipo_peca_id).any? 
      last_record_saldo = GarmentFinishedStock.where(tipo_peca_id: self.tipo_peca_id).last.saldo
    end

    if self.tipo_movimento == 'Entrada'
      self.saldo = last_record_saldo + self.quantidade
    else
      self.saldo = last_record_saldo - self.quantidade
    end
  end

  def saldo_nao_negativo
    last_record_saldo = 0
    if GarmentFinishedStock.any? && GarmentFinishedStock.where(tipo_peca_id: self.tipo_peca_id).any? 
      last_record_saldo = GarmentFinishedStock.where(tipo_peca_id: self.tipo_peca_id).last.saldo
    end

    last_record_saldo = 0 if last_record_saldo < 0

    if self.tipo_movimento == 'Saída' && !self.quantidade.nil? && !self.tipo_peca_id.nil?
      if last_record_saldo - self.quantidade < 0
        errors.add(:quantidade, " para #{self.tipo_peca.nome} excedeu #{self.quantidade - last_record_saldo}")
      end
    end
  end
end
