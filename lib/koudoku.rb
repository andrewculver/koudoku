require "koudoku/engine"
require "generators/koudoku/install_generator"
require "generators/koudoku/views_generator"

module Koudoku

  mattr_accessor :webhooks_api_key
  @@webhooks_api_key = nil
  
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
    :"#{Koudoku.subscriptions_owned_by}_id'"
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

end
