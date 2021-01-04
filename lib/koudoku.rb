require "koudoku/engine"
require "koudoku/errors"
require "generators/koudoku/install_generator"
require "generators/koudoku/views_generator"
require 'stripe_event'

module Koudoku
  mattr_accessor :subscriptions_owned_by
  @@subscriptions_owned_by = nil

  mattr_accessor :subscriptions_owned_through
  @@subscriptions_owned_through = nil

  def self.subscriptions_owned_through_or_by
    @@subscriptions_owned_through || @@subscriptions_owned_by
  end

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
    owner_class.model_name.route_key.to_sym
  end

  # e.g. :user_id
  def self.owner_foreign_key
    :"#{owner_class.table_name.singularize}_id"
  end

  # e.g. :user
  def self.owner_accessor_method
    owner_class.table_name.singularize.to_sym
  end

  # e.g. :user=
  def self.owner_assignment_method
    :"#{owner_accessor_method}="
  end

  # e.g. User
  def self.owner_class
    subscriptions_owned_by.to_s.classify.constantize
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
