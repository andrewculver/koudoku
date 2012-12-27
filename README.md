# Koudoku

Robust subscription support for Ruby on Rails apps using [Stripe](https://stripe.com). Makes it easy to manage actions related to new subscriptions, upgrades, downgrades, cancelations, as well as hooking up notifications, metrics logging, coupons, etc.

## Installation

Include the following in your `Gemfile`:

    gem 'koudoku'

## Usage

There are no generators at the moment, so you'll need to generate plans, subscriptions, and (optionally) coupons on your own:

### Subscriptions

    rails g model subscription stripe_id:string plan_id:integer last_four:string coupon_id:integer current_price:float user_id:integer
    
Only include `coupon_id` if you want to support coupons. The `user_id` property should actually be the foreign key for whatever model you want your subscriptions to relate to. (User is just the default.)

Then, dress up your subscription model by including the `Koudoku::Subscription` module and defining some essential relationships:

    class Subscription < ActiveRecord::Base
      include Koudoku::Subscription

      # Belongs to user. (This is the default.)
      attr_accessible :user_id
      belongs_to :user
  
      # Supports coupons.
      attr_accessible :coupon_id
      belongs_to :coupon

    end

### Plans

    rails g model plan name:string stripe_id:string price:float
    
The `stripe_id` for each plan must match the ID from Stripe. The price here isn't affected by (nor does it affect) the price in Stripe.

You'll need to create a few plans to start. (You don't need to create a plan to represent "free" accounts.)

    Plan.create(name: 'Personal', price: 10.00)
    Plan.create(name: 'Team', price: 30.00)
    Plan.create(name: 'Enterprise', price: 100.00)

### Coupons

Again, this is only required if you want to support coupons:

    rails g model coupon code:string free_trial_length:string


## Subscriptions That Belong to Models Other than User

Here's an example of a subscription that belongs to a company rather than a user:

    class Subscription < ActiveRecord::Base
      include Koudoku::Subscription

      # Ownership.
      attr_accessible :company_id
      belongs_to :company

      # Inform Koudoku::Subscription how to identify the owner of the subscription.
      def subscription_owner
        company
      end
  
      # Inform Koudoku::Subscription how to represent the owner in emails, etc.
      def subscription_owner_description
        "#{company.name} (#{company.primary_contact_name})"
      end

    end


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

