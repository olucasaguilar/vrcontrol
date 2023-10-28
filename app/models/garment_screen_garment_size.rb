class GarmentScreenGarmentSize < ApplicationRecord
  belongs_to :peca_serigrafia_peca, class_name: 'GarmentScreenGarment'
  belongs_to :tamanho, class_name: 'GarmentSize'

  validates :qtd_tamanho, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
