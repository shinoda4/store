class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false
      t.references :product, null: false

      t.integer :status, default: 0
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
  end
end
