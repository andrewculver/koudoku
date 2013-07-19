class Plan < ActiveRecord::Base
  has_many :subscriptions

  include Koudoku::Plan
  belongs_to :customer
  belongs_to :coupon
  has_many :subscriptions

end
