# this generator based on rails_admin's install generator.
# https://www.github.com/sferik/rails_admin/master/lib/generators/rails_admin/install_generator.rb

require 'rails/generators'

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html

module Koudoku
  class InstallGenerator < Rails::Generators::Base

    # Not sure what this does.
    source_root File.expand_path("../../../../app/views/koudoku/subscriptions", __FILE__)

    include Rails::Generators::Migration

    argument :subscription_owner_model, :type => :string, :required => true, :desc => "Owner of the subscription"
    desc "Koudoku installation generator"

    def install
      
      unless defined?(Koudoku)
        gem("koudoku")
      end
      
      require "securerandom"
      api_key = SecureRandom.uuid
      create_file 'config/initializers/koudoku.rb' do
      <<-RUBY
Koudoku.setup do |config|
  config.webhooks_api_key = "#{api_key}"
  config.subscriptions_owned_by = :user
  config.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  config.stripe_secret_key = ENV['STRIPE_SECRET_KEY']
  # config.free_trial_length = 30
end
RUBY
      end

      # Generate subscription.
      generate("model", "subscription stripe_id:string plan_id:integer last_four:string coupon_id:integer card_type:string current_price:float #{subscription_owner_model}_id:integer")
      gsub_file "app/models/subscription.rb", /ActiveRecord::Base/, "ActiveRecord::Base\n  include Koudoku::Subscription\n\n  belongs_to :#{subscription_owner_model}\n  belongs_to :coupon\n"
	  inject_into_file("app/models/subscription.rb", "  attr_accessible :credit_card_token\n", :before => 'end') if Rails::VERSION::STRING.start_with? '3'
      
      # Add the plans.
      generate("model", "plan name:string stripe_id:string price:float interval:string features:text highlight:boolean display_order:integer")
      gsub_file "app/models/plan.rb", /ActiveRecord::Base/, "ActiveRecord::Base\n  include Koudoku::Plan\n  belongs_to :#{subscription_owner_model}\n  belongs_to :coupon\n  has_many :subscriptions\n"

      # Add coupons.
      generate("model coupon code:string free_trial_length:string")
      gsub_file "app/models/coupon.rb", /ActiveRecord::Base/, "ActiveRecord::Base\n  has_many :subscriptions\n"
      
      # Update the owner relationship.
      gsub_file "app/models/#{subscription_owner_model}.rb", /ActiveRecord::Base/, "ActiveRecord::Base\n\n  # Added by Koudoku.\n  has_one :subscription\n\n"
      
      # Install the pricing table.
      ["_social_proof.html.erb"].each do |file|
        copy_file file, "app/views/koudoku/subscriptions/#{file}"
      end

      # Add webhooks to the route.
      gsub_file "config/routes.rb", /Application.routes.draw do/,  <<-RUBY
Application.routes.draw do

  # Added by Koudoku.
  mount Koudoku::Engine, at: 'koudoku'
  scope module: 'koudoku' do
    get 'pricing' => 'subscriptions#index', as: 'pricing'
  end

RUBY
      
      # Show the user the API key we generated.
      say "\nTo enable support for Stripe webhooks, point it to \"/koudoku/webhooks?api_key=#{api_key}\". This API key has been randomly generated, so it's unique to your application.\n\n"
      
    end

  end
end
