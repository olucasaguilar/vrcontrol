class EntityType < ApplicationRecord
  has_many :entities
  validates :nome, presence: true, uniqueness: true
end
