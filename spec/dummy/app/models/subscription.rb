class Subscription < ActiveRecord::Base
  include Koudoku::Subscription

  belongs_to :customer
  belongs_to :coupon

  attr_accessible :card_type, :coupon_id, :current_price, :customer_id, :last_four, :last_four, :plan_id, :stripe_id
end
