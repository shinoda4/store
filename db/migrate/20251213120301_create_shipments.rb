class CreateShipments < ActiveRecord::Migration[8.1]
  def change
    create_table :shipments do |t|
      t.references :subscription,
                   null: false,
                   foreign_key: { to_table: :subscriptions }
      t.string :tracking_number
      t.string :carrier
      t.integer :status
      t.datetime :shipped_at
      t.text :remark

      t.timestamps
    end
  end
end
