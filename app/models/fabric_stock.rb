class FabricStock < ApplicationRecord
  before_save :calculate_and_set_saldo
    
  belongs_to :tipo_tecido, class_name: 'FabricType'
  belongs_to :cor, class_name: 'Color'

  validates :tipo_movimento, :data_hora, presence: true
  validates :quantidade, numericality: { greater_than_or_equal_to: 1 }
  
  validate :saldo_nao_negativo

  private

  def calculate_and_set_saldo
    last_record_saldo = 0
    if FabricStock.any? && FabricStock.where(tipo_tecido_id: self.tipo_tecido_id, cor_id: self.cor_id).any?
      last_record_saldo = FabricStock.where(
                                            tipo_tecido_id: self.tipo_tecido_id, 
                                            cor_id: self.cor_id
                                            ).last.saldo
    end

    if self.tipo_movimento == 'Entrada'
      self.saldo = last_record_saldo + self.quantidade
    else
      self.saldo = last_record_saldo - self.quantidade
    end
  end

  def saldo_nao_negativo
    last_record_saldo = 0
    if FabricStock.any? && FabricStock.where(tipo_tecido_id: self.tipo_tecido_id, cor_id: self.cor_id).any?
      last_record_saldo = FabricStock.where(
                                            tipo_tecido_id: self.tipo_tecido_id, 
                                            cor_id: self.cor_id
                                            ).last.saldo
    end

    self.quantidade = 0 if self.quantidade.nil?
    
    if last_record_saldo - self.quantidade < 0
      unless self.cor.nil?
        errors.add(:quantidade, " disponível para a cor #{self.cor.nome} é de #{last_record_saldo}")
      end
    end
  end
end
