class FabricCut < ApplicationRecord
  belongs_to :cortador, class_name: 'Entity', foreign_key: 'cortador_id'
  #validates :cortador, presence: true
  validates :data_hora_ida, presence: true
end
