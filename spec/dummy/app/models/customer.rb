class Customer < ActiveRecord::Base

  # Added by Koudoku.
  has_one :subscription

end
