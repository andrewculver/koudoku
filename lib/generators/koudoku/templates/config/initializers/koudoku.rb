Koudoku.setup do |config|
  config.webhooks_api_key = "<%= @api_key %>"
  config.subscriptions_owned_by = :<%= subscription_owner_model %>
  config.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  config.stripe_secret_key = ENV['STRIPE_SECRET_KEY']
  # config.prorate = false # Default is true, set to false to disable prorating subscriptions
  # config.free_trial_length = 30
end
