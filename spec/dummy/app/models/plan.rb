class Plan < ActiveRecord::Base
  has_many :subscriptions

  include Koudoku::Plan
  belongs_to :customer
  belongs_to :coupon
  has_many :subscriptions

  attr_accessible :display_order, :features, :highlight, :name, :price, :stripe_id
end
