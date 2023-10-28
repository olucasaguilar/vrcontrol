class GarmentStock < ApplicationRecord
  before_save :calculate_and_set_saldo
  
  belongs_to :tipo_peca, class_name: 'GarmentType'
    
  validates :tipo_movimento, :data_hora, presence: true
  validates :quantidade, numericality: { greater_than_or_equal_to: 1 }
  
  validate :saldo_nao_negativo
  
  private

  def calculate_and_set_saldo
    last_record_saldo = 0
    if GarmentStock.any? && GarmentStock.where(tipo_peca_id: self.tipo_peca_id, costurada: self.costurada, estampada: self.estampada).any? 
      last_record_saldo = GarmentStock.where(tipo_peca_id: self.tipo_peca_id, 
                                             costurada: self.costurada,
                                             estampada: self.estampada).last.saldo
    end

    if self.tipo_movimento == 'Entrada'
      self.saldo = last_record_saldo + self.quantidade
    else
      self.saldo = last_record_saldo - self.quantidade
    end
  end

  def saldo_nao_negativo
    last_record_saldo = 0
    if GarmentStock.any? && GarmentStock.where(tipo_peca_id: self.tipo_peca_id, costurada: self.costurada, estampada: self.estampada).any? 
      last_record_saldo = GarmentStock.where(tipo_peca_id: self.tipo_peca_id, 
                                             costurada: self.costurada,
                                             estampada: self.estampada).last.saldo
    end

    if self.tipo_movimento == 'Saída'
      if last_record_saldo - self.quantidade < 0
        errors.add(:quantidade, " disponível para o tipo de peça #{self.tipo_peca_id.nome} é de #{last_record_saldo}")
      end
    end
  end
end
