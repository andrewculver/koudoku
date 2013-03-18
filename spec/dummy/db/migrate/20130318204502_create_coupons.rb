class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.string :free_trial_length

      t.timestamps
    end
  end
end
