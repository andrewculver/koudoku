require "koudoku/version"
require "koudoku/subscription"

module Koudoku

  mattr_accessor :webhooks_api_key
  @@webhooks_api_key = nil
  
  def self.setup
    yield self
  end
  
end
