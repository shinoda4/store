class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :shipments, dependent: :destroy

  enum :status, { active: 0, cancelled: 1, fulfilled: 2 }
  validates :quantity, numericality: { greater_than: 0 }

end
