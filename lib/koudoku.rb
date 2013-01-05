require "koudoku/engine"
require "generators/koudoku/install_generator"

module Koudoku

  mattr_accessor :webhooks_api_key
  @@webhooks_api_key = nil
  
  mattr_accessor :subscriptions_owned_by
  @@subscriptions_owned_by = nil
  
  def self.setup
    yield self
  end
  
end
