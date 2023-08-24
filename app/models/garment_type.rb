class GarmentType < ApplicationRecord
  validates :nome, presence: true, uniqueness: true
end
