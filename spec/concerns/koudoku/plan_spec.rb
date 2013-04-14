require 'spec_helper'

describe Koudoku::Plan do
  describe '#is_upgrade_from?' do
    before do
      class Plan
        attr_accessor :price
        include Koudoku::Plan
      end 
    end
    it 'returns true if the price is higher' do
      plan = Plan.new
      plan.price = 123.23
      cheaper_plan = Plan.new
      cheaper_plan.price = 61.61
      plan.is_upgrade_from?(cheaper_plan).should be_true
    end
    it 'returns true if the price is the same' do
      plan = Plan.new
      plan.price = 123.23
      plan.is_upgrade_from?(plan).should be_true
    end
    it 'returns false if the price is the same or higher' do
      plan = Plan.new
      plan.price = 61.61
      more_expensive_plan = Plan.new
      more_expensive_plan.price = 123.23
      plan.is_upgrade_from?(more_expensive_plan).should be_false
    end
    it 'handles a nil value gracefully' do
      plan = Plan.new
      plan.price = 123.23
      cheaper_plan = Plan.new
      lambda {
        plan.is_upgrade_from?(cheaper_plan).should be_true
      }.should_not raise_error
    end
  end
end
