class FabricStockExit < ApplicationRecord
  belongs_to :tecido_corte, class_name: 'FabricCut'
  belongs_to :estoque_tecido, class_name: 'FabricStock'
  belongs_to :tipo_peca, class_name: 'GarmentType'

  validates :tecido_corte, presence: true
  validates :estoque_tecido, presence: true, uniqueness: true
  validates :tipo_peca, presence: true
end
