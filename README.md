# Koudoku

Robust subscription support for Ruby on Rails apps using [Stripe](https://stripe.com). Makes it easy to manage actions related to new subscriptions, upgrades, downgrades, cancelations, payment failures, as well as hooking up notifications, metrics logging, coupons, etc.

## Installation

Include the following in your `Gemfile`:

    gem 'koudoku'
    
After running `bundle install`, you can run a Rails generator to do the rest. Before installing, the model you'd like to have own subscriptions must already exist. (In many cases this will be "`user`".)

    rails g koudoku:install user

## Using Coupons

While more robust coupon support is expected in the future, the simple way to use a coupon is to first create it:

    coupon = Coupon.create(code: '30-days-free', free_trial_length: 30)
    
Then assign it to a _new_ subscription before saving:

    subscription = Subscription.new(...)
    subscription.coupon = coupon
    subscription.save
    
## Implementing Logging, Notifications, etc.

The included module defined the following empty "template methods" which you're able to provide an implementation for:

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

Support for Stripe Webhooks is still quite limited. To react to some of the webhooks that are currently handled, you can implement the following template methods of the `Subscription` class:

  - `payment_succeeded(amount)`
  - `charge_failed`
  - `charge_disputed`
  
No additional information is currently handled from the webhook request body.