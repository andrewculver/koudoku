module Koudoku
  module ApplicationHelper

    def plan_price(plan)
      "#{number_to_currency(plan.price)}/#{plan_interval(plan)}"
    end

    def plan_interval(plan)
      interval = %w(month year week 6-month 3-month).include?(plan.interval) ? plan.interval.delete('-') : 'month'
      I18n.t("koudoku.plan_intervals.#{interval}")
    end

    def plan_difference(subscription, other_plan)
      if subscription.plan.nil?
        if subscription.persisted?
          I18n.t('koudoku.plan_upgrade')
        else
          if Koudoku.free_trial?
            I18n.t('koudoku.start_trial')
          else
            I18n.t('koudoku.plan_upgrade')
          end
        end
      else
        if other_plan.is_upgrade_from?(subscription.plan)
          I18n.t('koudoku.plan_upgrade')
        else
          I18n.t('koudoku.plan_downgrade')
        end
      end
    end

    # returns TRUE if the controller belongs to Koudoku
    # false in all other cases, for convenience when executing filters 
    # in the main application
    def koudoku_controller?
      is_a? Koudoku::ApplicationController
    end
  end
end
