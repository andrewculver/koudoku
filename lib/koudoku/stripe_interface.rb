module Koudoku

  StripeInterface = case
    when defined?(Stripe)
      Stripe
    when defined?(Paymill)
      Paymill
    else
      raise LoadError, %Q{Koudoku only works with either the 'stripe' gem or the 'paymill' gem. So please add "gem 'stripe'" or "gem 'paymill'" to your Gemfile _before_ loading koudoku.}
    end

  class <<StripeInterface
    def stripe?
      stripe_library_name == :stripe
    end

    def paymill?
      stripe_library_name == :paymill
    end

    def stripe_library_name
      self.name.underscore.to_sym
    end

    def error_class
      case
      when self.stripe?
        Stripe::StripeError
      when self.paymill?
        Paymill::PaymillError
      end
    end

  end

end
