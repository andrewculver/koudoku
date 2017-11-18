class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :stripe_id
      t.float :price
      t.text :features
      t.boolean :highlight
      t.integer :display_order

      t.timestamps
    end
  end
end
