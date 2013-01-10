# Koudoku

Robust subscription support for Ruby on Rails apps using [Stripe](https://stripe.com). Makes it easy to manage actions related to new subscriptions, upgrades, downgrades, cancelations, payment failures, as well as hooking up notifications, metrics logging, coupons, etc.

## Installation

Include the following in your `Gemfile`:

    gem 'koudoku'
    
After running `bundle install`, you can run a Rails generator to do the rest. Before installing, the model you'd like to have own subscriptions must already exist. (In many cases this will be `user`. It may also be something like `company`, etc.)

    rails g koudoku:install user
    
After installing, you'll need to add some subscription plans.

    Plan.create(name: 'Personal', price: 10.00, stripe_id: '1')
    Plan.create(name: 'Team', price: 30.00, stripe_id: '2')
    Plan.create(name: 'Enterprise', price: 100.00, stripe_id: '3')
    
### Configuring Stripe API Keys

You can supply your publishable and secret API keys in `config/initializers/koudoku.rb`. However, by default it will use the `STRIPE_PUBLISHABLE_KEY` and `STRIPE_SECRET_KEY` shell environment variables. This encourages people to keep these API keys out of version control. You may want to rename these environment variables to be more application specific.

In a bash shell, you can set them in `~/.bash_profile` like so:

    export STRIPE_PUBLISHABLE_KEY=pk_0CJwDH9sdh98f79FDHDOjdiOxQob0
    export STRIPE_SECRET_KEY=sk_0CJwFDIUshdfh97JDJOjZ5OIDjOCH
    
(Reload your terminal for these settings to take effect.)
    
On Heroku you accomplish this same effect with [Config Vars](https://devcenter.heroku.com/articles/config-vars):

    heroku config:add STRIPE_PUBLISHABLE_KEY=pk_0CJwDH9sdh98f79FDHDOjdiOxQob0
    heroku config:add STRIPE_SECRET_KEY=sk_0CJwFDIUshdfh97JDJOjZ5OIDjOCH
    
## User-Facing Subscription Management

Users can view available plans, select a plan, enter credit card details, review their subscription, change plans, and cancel at the following route:

    koudoku_owner_subscriptions_path(@user)
  
In these paths, `owner` refers to `User` by default, or whatever model has been configured to be the owner of the `Subscription` model.

A number of views are provided by default. To customize the views, use the following generator:

    rails g koudoku:views

### Pricing Table

Koudoku ships with a stock pricing table. By default it depends on Twitter Bootstrap, but also has some additional styles required. In order to import these styles, add the following to your `app/assets/stylesheets/application.css`:

    *= require 'koudoku/pricing-table'
    
Or, if you've replaced your `application.css` with an `application.scss` (like I always do):

    @import "koudoku/pricing-table"
    
    
## Using Coupons

While more robust coupon support is expected in the future, the simple way to use a coupon is to first create it:

    coupon = Coupon.create(code: '30-days-free', free_trial_length: 30)
    
Then assign it to a _new_ subscription before saving:

    subscription = Subscription.new(...)
    subscription.coupon = coupon
    subscription.save
    
## Implementing Logging, Notifications, etc.

The included module defines the following empty "template methods" which you're able to provide an implementation for in `Subscription`:

 - `prepare_for_plan_change`
 - `prepare_for_new_subscription`
 - `prepare_for_upgrade`
 - `prepare_for_downgrade`
 - `prepare_for_cancelation`
 - `finalize_plan_change!`
 - `finalize_new_subscription!`
 - `finalize_upgrade!`
 - `finalize_downgrade!`
 - `finalize_cancelation!`
 - `card_was_declined`
 
Be sure to include a call to `super` in each of your implementations, especially if you're using multiple concerns to break all this logic into smaller pieces.

Between `prepare_for_*` and `finalize_*`, so far I've used `finalize_*` almost exclusively. The difference is that `prepare_for_*` runs before we settle things with Stripe, and `finalize_*` runs after everything is settled in Stripe. For that reason, please be sure not to implement anything in `finalize_*` implementations that might cause issues with ActiveRecord saving the updated state of the subscription.

### Stripe Webhooks

During the installation process, a path and API key will be printed out that you can configure in the Stripe account panel that will allow your application to receive information about recurring transactions as they happen. (These are useful for reacting to expired credit cards on file and revenue tracking.)

Support for Stripe Webhooks is still quite limited. You can implement the following template methods of the `Subscription`:

  - `payment_succeeded(amount)`
  - `charge_failed`
  - `charge_disputed`
  
As mentioned before, be sure to call `super` in your implementations. No additional information from Stripe is currently handled from the webhook request body.