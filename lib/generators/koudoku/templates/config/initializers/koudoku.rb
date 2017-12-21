Koudoku.setup do |config|
  config.subscriptions_owned_by = :<%= subscription_owner_model %>
  config.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  config.stripe_secret_key = ENV['STRIPE_SECRET_KEY']

  Stripe.api_version = '2017-08-15' # Making sure the API version used is compatible.
  # config.prorate = false # Default is true, set to false to disable prorating subscriptions
  # config.free_trial_length = 30

  # Specify layout you want to use for the subscription pages, default is application
  config.layout = 'application'

  # you can subscribe to additional webhooks here
  # we use stripe_event under the hood and you can subscribe using the
  # stripe_event syntax on the config object:
  # config.subscribe 'charge.failed', Koudoku::ChargeFailed

end
