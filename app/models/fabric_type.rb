class FabricType < ApplicationRecord
  validates :nome, presence: true, uniqueness: true
end
