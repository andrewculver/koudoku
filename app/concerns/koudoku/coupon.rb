module Koudoku::Coupon
  extend ActiveSupport::Concern

  included do
    VALID_DURATIONS = %['repeating', 'once', 'forever']

    # Callbacks
    after_create  :create_stripe_coupon
    after_destroy :delete_from_stripe

    # Validations
    validates_presence_of :duration, :code
    validates_uniqueness_of :code
    validate :exclusivity_of_percentage_and_amount_off
    validate :presence_of_atleast_percentage_or_amount_off
    validate :duration_in_months_is_relative_to_duration
    validate :stripe_valid_duration

    ## Stripe implementation

    def create_stripe_coupon
      coupon_hash = {
        id: code,
        duration: duration,
        duration_in_months: duration_in_months,
        max_redemptions: max_redemptions,
        percent_off: percentage_off,
        amount_off: amount_off,
      }
      coupon_hash[:redeem_by] = redeem_by.strftime('%s') if redeem_by.present?

      Stripe::Coupon.create(coupon_hash)
    end

    def delete_from_stripe
      Stripe::Coupon.retrieve(code).delete
    end

    private

    def duration_in_months_is_relative_to_duration
      if duration != 'repeating' && duration_in_months.present?
        errors.add(:duration_in_months, 'can only be set when duration is :repeating')
      end
    end

    def exclusivity_of_percentage_and_amount_off
      if percentage_off.present? && amount_off.present?
        errors.add(:percentage_off, 'cannot set both amount_off and percentage_off')
      end
    end

    def presence_of_atleast_percentage_or_amount_off
      if percentage_off.blank? && amount_off.blank?
        errors.add(:percentage_off, 'need to set atleast one off attribute')
      end
    end

    def stripe_valid_duration
      errors.add(:duration, "is not valid. Valid durations include #{VALID_DURATIONS.join(',')}") unless VALID_DURATIONS.include? duration
    end
  end
end
