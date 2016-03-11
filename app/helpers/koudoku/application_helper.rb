module Koudoku
  module ApplicationHelper

    def plan_price(plan, subscription=nil)
      if plan.pwyc
        if subscription.persisted?
          qty = subscription.try(:quantity) || 1
          "#{number_to_currency(plan.price * qty)}/#{plan_interval(plan)}"
        else
          t('koudoku.pay_what_you_can')
        end
      else
        "#{number_to_currency(plan.price)}/#{plan_interval(plan)}"
      end
    end

    def plan_interval(plan)
      interval = %w(month year week 6-month 3-month).include?(plan.interval) ? plan.interval.delete('-') : 'month'
      I18n.t("koudoku.plan_intervals.#{interval}")
    end

    # returns TRUE if the controller belongs to Koudoku
    # false in all other cases, for convenience when executing filters
    # in the main application
    def koudoku_controller?
      is_a? Koudoku::ApplicationController
    end
  end
end
