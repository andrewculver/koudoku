class Subscription < ActiveRecord::Base
  include Koudoku::Subscription

  <%= "attr_accessible :credit_card_token" if Rails::VERSION::MAJOR == 3 %>
  belongs_to :<%= subscription_owner_model %>
  belongs_to :coupon, optional: true

end
