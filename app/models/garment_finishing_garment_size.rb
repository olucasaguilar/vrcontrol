class GarmentFinishingGarmentSize < ApplicationRecord
  belongs_to :peca_acabamento_peca, class_name: 'GarmentFinishingGarment'
  belongs_to :tamanho, class_name: 'GarmentSize'

  validates :qtd_tamanho, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
