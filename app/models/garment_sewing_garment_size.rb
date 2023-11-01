class GarmentSewingGarmentSize < ApplicationRecord
  belongs_to :peca_costura_peca, class_name: 'GarmentSewingGarment'
  belongs_to :tamanho, class_name: 'GarmentSize'

  validates :qtd_tamanho, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
