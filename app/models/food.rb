class Food < ApplicationRecord
  belongs_to :fridge

  validates :item, presence: true
end
