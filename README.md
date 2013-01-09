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