class FabricCutGarmentSize < ApplicationRecord
  belongs_to :tecido_corte_peca, class_name: 'FabricCutGarment'
  belongs_to :tamanho, class_name: 'GarmentSize'

  validates :qtd_tamanho, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
