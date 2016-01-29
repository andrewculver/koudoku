# Koudoku

[![Gem Version](https://badge.fury.io/rb/koudoku.png)](https://rubygems.org/gems/koudoku) [![Code Climate](https://codeclimate.com/github/andrewculver/koudoku.png)](https://codeclimate.com/github/andrewculver/koudoku) [![Build Status](https://travis-ci.org/andrewculver/koudoku.png)](https://travis-ci.org/andrewculver/koudoku)

Robust subscription support for Ruby on Rails apps using [Stripe](https://stripe.com), including out-of-the-box pricing pages, payment pages, and  subscription management for your customers. Also makes it easy to manage logic related to new subscriptions, upgrades, downgrades, cancellations, payment failures, and streamlines hooking up notifications, metrics logging, etc.

To see an example of Koudoku in action, please visit [Koudoku.org](http://koudoku.org/).

<small><a href="http://churnbuster.io"><img src="https://s3.amazonaws.com/andrew-culver-images/churn-buster/koudoku-readme.png" width="196" height="38" alt="Churn Buster" /></a><br>Koudoku is authored and maintained by [Andrew Culver](http://twitter.com/andrewculver) and [Christoph Engelhardt](https://twitter.com/itengelhardt). If you find it useful, consider checking out [Churn Buster](http://churnbuster.io). It's designed to help you handle the pain points you'll run into when doing payments at scale.</small>

## Installation

Include the following in your `Gemfile`:

```ruby
    gem 'koudoku'
```    

After running `bundle install`, you can run a Rails generator to do the rest. Before installing, the model you'd like to have own subscriptions must already exist. (In many cases this will be `user`. It may also be something like `company`, etc.)

```ruby
    rails g koudoku:install user
    rake db:migrate
```
    
Add the following to `app/views/layouts/application.html.erb` before your `<head>` tag closes:

```ruby
    <%= yield :koudoku %>
```
    
(This allows us to inject a Stripe `<script>` tag in the correct place. If you don't, the payment form will not work.)
  
After installing, you'll need to add some subscription plans. (You can see an explanation of each of the attributes in the table below.)

```ruby
    Plan.create({
      name: 'Personal',
      price: 10.00,
      interval: 'month',
      stripe_id: '1',
      features: ['1 Project', '1 Page', '1 User', '1 Organization'].join("\n\n"),
      display_order: 1
    })

    Plan.create({
      name: 'Team',
      highlight: true, # This highlights the plan on the pricing page.
      price: 30.00,
      interval: 'month',
      stripe_id: '2',
      features: ['3 Projects', '3 Pages', '3 Users', '3 Organizations'].join("\n\n"),
      display_order: 2
    })
    
    Plan.create({
      name: 'Enterprise',
      price: 100.00, 
      interval: 'month',
      stripe_id: '3', 
      features: ['10 Projects', '10 Pages', '10 Users', '10 Organizations'].join("\n\n"), 
      display_order: 3
    })
```    

To help you understand the attributes:
    
| Attribute       | Type    | Function |
| --------------- | ------- | -------- |
| `name`          | string  | Name for the plan to be presented to customers. |
| `price`         | float   | Price per billing cycle. |
| `interval`      | string  | *Optional.* What is the billing cycle? Valid options are `month`, `year`, `week`, `3-month`, `6-month`. Defaults to `month`. |
| `stripe_id`     | string  | The Plan ID in Stripe. |
| `features`      | string  | A list of features. Supports Markdown syntax. |
| `display_order` | integer | Order in which to display plans. |
| `highlight`     | boolean | *Optional.* Whether to highlight the plan on the pricing page. |

The only view installed locally into your app by default is the `koudoku/subscriptions/_social_proof.html.erb` partial which is displayed alongside the pricing table. It's designed as a placeholder where you can provide quotes about your product from customers that could positively influence your visitors.
    
### Configuring Stripe API Keys

You can supply your publishable and secret API keys in `config/initializers/koudoku.rb`. However, by default it will use the `STRIPE_PUBLISHABLE_KEY` and `STRIPE_SECRET_KEY` shell environment variables. This encourages people to keep these API keys out of version control. You may want to rename these environment variables to be more application specific.

In a bash shell, you can set them in `~/.bash_profile` like so:

```bash
    export STRIPE_PUBLISHABLE_KEY=pk_0CJwDH9sdh98f79FDHDOjdiOxQob0
    export STRIPE_SECRET_KEY=sk_0CJwFDIUshdfh97JDJOjZ5OIDjOCH
```
    
(Reload your terminal for these settings to take effect.)
    
On Heroku you accomplish this same effect with [Config Vars](https://devcenter.heroku.com/articles/config-vars):

```bash
    heroku config:add STRIPE_PUBLISHABLE_KEY=pk_0CJwDH9sdh98f79FDHDOjdiOxQob0
    heroku config:add STRIPE_SECRET_KEY=sk_0CJwFDIUshdfh97JDJOjZ5OIDjOCH
```    

## User-Facing Subscription Management

By default a `pricing_path` route is defined which you can link to in order to show visitors a pricing table. If a user is signed in, this pricing table will take into account their current plan. For example, you can link to this page like so:

```ruby
    <%= link_to 'Pricing', main_app.pricing_path %>
```   
   
(Note: Koudoku uses the application layout, so it's important that application paths referenced in that layout are prefixed with "`main_app.`" like you see above or Rails will try to look the paths up in the Koudoku engine instead of your application.)

Existing users can view available plans, select a plan, enter credit card details, review their subscription, change plans, and cancel at the following route:

```ruby
    koudoku.owner_subscriptions_path(@user)
```

In these paths, `owner` refers to `User` by default, or whatever model has been configured to be the owner of the `Subscription` model.

A number of views are provided by default. To customize the views, use the following generator:

```ruby
    rails g koudoku:views
```

### Pricing Table

Koudoku ships with a stock pricing table. By default it depends on Twitter Bootstrap, but also has some additional styles required. In order to import these styles, add the following to your `app/assets/stylesheets/application.css`:

```css
    *= require 'koudoku/pricing-table'
```  
  
Or, if you've replaced your `application.css` with an `application.scss` (like I always do):

```css
    @import "koudoku/pricing-table"
``` 
   
## Using Coupons
Coupons mirror the functionality of Stripe coupons https://stripe.com/docs/api#coupons, creating a coupon subsequently adds that coupon to your Stripe account. 

```ruby
    coupon = Coupon.create(code: '10percentoff', duration: 'repeating', percent_off: 10)
```   
   
And can then be assigned to a new subscription by setting a session variable.
```ruby
    session[:koudoku_coupon_code] = '10percentoff'
```    
*Note:*
Destroying a coupon locally will delete that coupon from Stripe and Stripe doesn't support updating coupons after they've been created. 

## Implementing Logging, Notifications, etc.

The included module defines the following empty "template methods" which you're able to provide an implementation for in `Subscription`:

 - `prepare_for_plan_change`
 - `prepare_for_new_subscription`
 - `prepare_for_upgrade`
 - `prepare_for_downgrade`
 - `prepare_for_cancelation`
 - `prepare_for_card_update`
 - `finalize_plan_change!`
 - `finalize_new_subscription!`
 - `finalize_upgrade!`
 - `finalize_downgrade!`
 - `finalize_cancelation!`
 - `finalize_card_update!`
 - `card_was_declined`
 
Be sure to include a call to `super` in each of your implementations, especially if you're using multiple concerns to break all this logic into smaller pieces.

Between `prepare_for_*` and `finalize_*`, so far I've used `finalize_*` almost exclusively. The difference is that `prepare_for_*` runs before we settle things with Stripe, and `finalize_*` runs after everything is settled in Stripe. For that reason, please be sure not to implement anything in `finalize_*` implementations that might cause issues with ActiveRecord saving the updated state of the subscription.

### Webhooks

We use [stripe_event](https://github.com/integrallis/stripe_event) under the hood to support webhooks.
The default webhooks URL is `/koudoku/webhooks`.

You can add your own webhooks using the (reduced) stripe_event syntax in the `config/initializers/koudoku.rb` file: 

```
# /config/initializers/koudoku.rb
Koudoku.setup do |config|
  config.subscriptions_owned_by = :user
  config.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  config.stripe_secret_key = ENV['STRIPE_SECRET_KEY']
  
  # add webhooks
  config.subscribe 'charge.failed', YourChargeFailed
end

``` 
