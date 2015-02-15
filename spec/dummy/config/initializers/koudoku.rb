Koudoku.setup do |config|
  #config.webhooks_api_key = "2f1a9b40-abe4-4bbc-86c8-8e7bd000c8b3"
  config.subscriptions_owned_by = :customer
  config.stripe_publishable_key = 'not_stripe_publishable_key'
  config.stripe_secret_key = 'not_stripe_secret_key'
  config.free_trial_length = 30
end
