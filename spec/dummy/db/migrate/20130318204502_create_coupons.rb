class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :code
      t.string :free_trial_length

      t.timestamps
    end
  end
end
