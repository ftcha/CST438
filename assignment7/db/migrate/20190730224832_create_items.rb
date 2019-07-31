class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :description
      t.float :price
      t.integer :stockQty
    end
  end
end
