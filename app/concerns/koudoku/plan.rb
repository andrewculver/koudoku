module Koudoku::Plan
  extend ActiveSupport::Concern

  included do

  end

  module ClassMethods

  end

  def is_upgrade_from?(plan)
    self.price >= plan.price
  end

end
