class Customer < ActiveRecord::Base

  # Added by Koudoku.
  has_one :subscription

  attr_accessible :email
end
