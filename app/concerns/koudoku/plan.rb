module Koudoku::Plan
  extend ActiveSupport::Concern

  included do

  end

  module ClassMethods

  end

  def is_upgrade_from?(plan)
    (price || 0) >= (plan.price || 0)
  end

end
