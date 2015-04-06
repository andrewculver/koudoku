require 'spec_helper'
describe Koudoku::ApplicationHelper, type: :helper do
  describe "#plan_price" do
    it "includes the price and defaults to monthly" do
      plan = Plan.new(price: 12.34)
      expect(helper.plan_price(plan)).to eq "$12.34/month"
    end
    it "supports monthly plans" do
      plan = Plan.new(price: 12.34, interval: 'month')
      expect(helper.plan_price(plan)).to eq "$12.34/month"
    end
    it "supports weekly plans" do
      plan = Plan.new(price: 12.34, interval: 'week')
      expect(helper.plan_price(plan)).to eq "$12.34/week"
    end
    it "supports annual plans" do
      plan = Plan.new(price: 12.34, interval: 'year')
      expect(helper.plan_price(plan)).to eq "$12.34/year"
    end
    it "supports semi-annual plans" do
      plan = Plan.new(price: 12.34, interval: '6-month')
      expect(helper.plan_price(plan)).to eq "$12.34/half-year"
    end
    it "supports quarterly plans" do
      plan = Plan.new(price: 12.34, interval: '3-month')
      expect(helper.plan_price(plan)).to eq "$12.34/quarter"
    end
  end 
end
