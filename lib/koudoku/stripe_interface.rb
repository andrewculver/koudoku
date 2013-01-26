module Koudoku

  StripeInterface = case
    when defined?(Stripe)
      Stripe
    when defined?(Paymill)
      Paymill
    else
      raise LoadError, %Q{Koudoku only works with either the 'stripe' gem or the 'paymill' gem. So please add "gem 'stripe'" or "gem 'paymill'" to your Gemfile _before_ loading koudoku.}
    end

end
