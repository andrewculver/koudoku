require 'spec_helper'

describe Koudoku::Plan do
  describe '#is_upgrade_from?' do

    class FakePlan
      attr_accessor :price
      include Koudoku::Plan
    end 

    it 'returns true if the price is higher' do
      plan = FakePlan.new
      plan.price = 123.23
      cheaper_plan = FakePlan.new
      cheaper_plan.price = 61.61
      expect(plan.is_upgrade_from?(cheaper_plan)).to eq(true)
    end
    it 'returns true if the price is the same' do
      plan = FakePlan.new
      plan.price = 123.23
      expect(plan.is_upgrade_from?(plan)).to eq(true)
    end
    it 'returns false if the price is the same or higher' do
      plan = FakePlan.new
      plan.price = 61.61
      more_expensive_plan = FakePlan.new
      more_expensive_plan.price = 123.23
      expect(plan.is_upgrade_from?(more_expensive_plan)).to eq(false)
    end
    it 'handles a nil value gracefully' do
      plan = FakePlan.new
      plan.price = 123.23
      cheaper_plan = FakePlan.new
      expect {
        expect(plan.is_upgrade_from?(cheaper_plan)).to eq(true)
      }.not_to raise_error
    end
  end
end
