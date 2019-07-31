class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :email
      t.string :lastName
      t.string :firstName
      t.float :lastOrder
      t.float :lastOrder2
      t.float :lastOrder3
      t.float :award
    end
  end
end
