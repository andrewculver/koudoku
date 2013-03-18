class Coupon < ActiveRecord::Base
  attr_accessible :code, :free_trial_length
end
