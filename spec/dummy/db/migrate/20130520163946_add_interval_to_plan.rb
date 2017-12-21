class AddIntervalToPlan < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :interval, :string
  end
end
