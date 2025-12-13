module Subscriptions
  class CancelService
    def initialize(subscription:)
      @subscription = subscription
    end

    def call
      ActiveRecord::Base.transaction do
        @quantity = @subscription.quantity
        @subscription.status = "cancelled"
        @subscription.save
        @subscription.product.lock!
        @subscription.product.inventory_count += @quantity
        @subscription.product.save!
        @subscription
      end
    end
  end
end