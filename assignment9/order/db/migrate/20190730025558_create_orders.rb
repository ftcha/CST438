class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :itemId
      t.string :description
      t.integer :customerId
      t.float :price
      t.float :award
      t.float :total

      t.timestamps
    end
  end
end
