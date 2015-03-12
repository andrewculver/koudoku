class Plan < ActiveRecord::Base
  has_many :subscriptions

  include Koudoku::Plan
  attr_accessible :display_order, :features, :highlight, :interval, :name, :price, :stripe_id
end
