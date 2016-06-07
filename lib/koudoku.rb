require "koudoku/engine"
require "generators/koudoku/install_generator"
require "generators/koudoku/views_generator"
require 'stripe_event'

module Koudoku
  mattr_accessor :subscriptions_owned_by
  @@subscriptions_owned_by = nil

  mattr_accessor :stripe_publishable_key
  @@stripe_publishable_key = nil

  mattr_accessor :stripe_secret_key
  @@stripe_secret_key = nil

  mattr_accessor :free_trial_length
  @@free_trial_length = nil

  mattr_accessor :prorate
  @@prorate = true


  @@layout = nil

  def self.layout
    @@layout || 'application'
  end

  def self.layout=(layout)
    @@layout = layout
  end

  def self.webhooks_api_key=(key)
    raise "Koudoku no longer uses an API key to secure webhooks, please delete the line from \"config/initializers/koudoku.rb\""
  end

  def self.setup
    yield self

    # Configure the Stripe gem.
    Stripe.api_key = stripe_secret_key
  end

  # e.g. :users
  def self.owner_resource
    subscriptions_owned_by.to_s.pluralize.to_sym
  end

  # e.g. :user_id
  def self.owner_id_sym
    :"#{Koudoku.subscriptions_owned_by}_id"
  end

  # e.g. :user=
  def self.owner_assignment_sym
    :"#{Koudoku.subscriptions_owned_by}="
  end

  # e.g. User
  def self.owner_class
    Koudoku.subscriptions_owned_by.to_s.classify.constantize
  end

  def self.free_trial?
    free_trial_length.to_i > 0
  end


  #
  # STRIPE_EVENT section
  #
  def self.subscribe(name, callable = Proc.new)
    StripeEvent.subscribe(name, callable)
  end

  def self.instrument(name, object)
    StripeEvent.backend.instrument(StripeEvent.namespace.call(name), object)
  end

  def self.all(callable = Proc.new)
    StripeEvent.all(callable)
  end

end
