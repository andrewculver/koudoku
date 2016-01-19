class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.string :free_trial_length
      t.integer :coupons, :interval, :integer
      t.float :coupons, :amount_off, :float
      t.integer :coupons, :percentage_off, :integer
      t.datetime :coupons, :redeem_by, :datetime
      t.integer :coupons, :max_redemptions, :integer
      t.integer :coupons, :duration, :integer
      t.integer :coupons, :duration_in_months, :integer

      t.timestamps
    end
  end
end
