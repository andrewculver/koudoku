class Coupon < ActiveRecord::Base
  include Koudoku::Coupon

  has_many :subscriptions

end
