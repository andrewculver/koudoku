module Koudoku::Plan
  extend ActiveSupport::Concern

  included do

  end

  module ClassMethods

  end

  module InstanceMethods
    
    def is_upgrade_from?(plan)
      self.price >= plan.price
    end

  end

end
