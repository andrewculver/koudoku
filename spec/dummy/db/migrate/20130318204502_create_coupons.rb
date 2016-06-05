class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.string :free_trial_length
      t.integer :coupons, :interval
      t.float :coupons, :amount_off
      t.integer :coupons, :percentage_off
      t.datetime :coupons, :redeem_by
      t.integer :coupons, :max_redemptions
      t.string :coupons, :duration
      t.integer :coupons, :duration_in_months

      t.timestamps
    end
  end
end
