require "koudoku/version"
require "koudoku/subscription"
require "koudoku/webhooks_controller"
require "generators/koudoku/install_generator"

# Load all rake tasks.
Dir["tasks/**/*.rake"].each { |ext| load ext } if defined?(Rake)

module Koudoku

  mattr_accessor :webhooks_api_key
  @@webhooks_api_key = nil
  
  def self.setup
    yield self
  end
  
end
