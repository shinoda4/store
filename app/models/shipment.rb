class Shipment < ApplicationRecord

  belongs_to :subscription

  enum :status, {
    pending: 0, # 待发货
    shipped: 1, # 已发货
    delivered: 2 # 已签收
  }
end
