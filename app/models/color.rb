class Color < ApplicationRecord
  validates :nome, presence: true, uniqueness: true
end
