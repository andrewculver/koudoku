class Coupon < ActiveRecord::Base
  
  has_many :subscriptions

end
