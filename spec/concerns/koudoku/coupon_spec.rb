require 'spec_helper'

describe Koudoku::Coupon do
  describe "validations" do
    before :each do
      @coupon = Coupon.new(duration: 'once', code: 'code', percentage_off: 10)
    end

    it "invalid if amount_off and percentage_off set at the sametime" do
      @coupon.amount_off = 1.99
      @coupon.percentage_off = 50

      expect(@coupon).to_not be_valid
    end

    it "valid if only percentage_off is set" do
      @coupon.amount_off = nil
      @coupon.percentage_off = 50

      expect(@coupon).to be_valid
    end

    it "valid if only amount_off is set" do
      @coupon.amount_off = 1.99
      @coupon.percentage_off = nil

      expect(@coupon).to be_valid
    end

    it "invalid if neither amount_off or percentage_off is set" do
      @coupon.amount_off = nil
      @coupon.percentage_off = nil

      expect(@coupon).to_not be_valid
    end

    it "valid if duration_in_months is set when duration is repeating " do
      @coupon.duration = 'repeating'
      @coupon.duration_in_months = 2
      expect(@coupon).to be_valid
    end

    it "invalid if duration_in_months is set when duration not repeating" do
      @coupon.duration = 'once'
      @coupon.duration_in_months = 2

      expect(@coupon).to_not be_valid
    end
  end
end
