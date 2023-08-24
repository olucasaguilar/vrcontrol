class GarmentSize < ApplicationRecord
  validates :nome, presence: true, uniqueness: true
end
