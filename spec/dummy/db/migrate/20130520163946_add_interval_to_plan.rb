class AddIntervalToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :interval, :string
  end
end
