require 'stripe'
module Koudoku
  class Engine < ::Rails::Engine
    isolate_namespace Koudoku
    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer 'koudoku.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        include Koudoku::ApplicationHelper
      end
    end

  end
end
