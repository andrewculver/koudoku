require "koudoku/engine"
require "generators/koudoku/install_generator"

module Koudoku

  mattr_accessor :webhooks_api_key
  @@webhooks_api_key = nil
  
  mattr_accessor :subscriptions_owned_by
  @@subscriptions_owned_by = nil
  
  mattr_accessor :stripe_publishable_key
  @@stripe_publishable_key = nil
  
  mattr_accessor :stripe_secret_key
  @@stripe_secret_key = nil
  
  def self.setup
    yield self
    
    # Configure the Stripe 
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end
  
  # e.g. :users
  def self.owner_resource
    subscriptions_owned_by.to_s.pluralize.to_sym
  end
  
  # e.g. :user_id
  def self.owner_id_sym
    # e.g. :user_id
    (Koudoku.subscriptions_owned_by.to_s + '_id').to_sym
  end

  # e.g. Users
  def self.owner_class
    # e.g. User
    Koudoku.subscriptions_owned_by.to_s.classify.constantize
  end
  
end
