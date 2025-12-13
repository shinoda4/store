module Subscriptions
  class CreateService
    def initialize(user:, product:, quantity:)
      @user = user
      @product = product
      @quantity = quantity.to_i
    end

    def call
      ActiveRecord::Base.transaction do
        subscription = Subscription.create!(
          user: @user,
          product: @product,
          quantity: @quantity,
          status: :active
        )
        @product.lock!
        @product.inventory_count -= @quantity
        @product.save!

        subscription
      end

    end
  end

end
