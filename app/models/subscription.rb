class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :product

  enum :status, { active: 0, cancelled: 1, fulfilled: 2 }
  validates :quantity, numericality: { greater_than: 0 }

end
