## Version 0.0.12 (NOT released on rubygems)
author: Christoph Engelhardt (@yas4891)

This version has a breaking change regarding webhooks.
Koudoku now uses stripe_engine under the hood.  
You need to follow these instructions even if you do NOT use webhooks: 

Go to `config/initializers/koudoku.rb` and remove the line `config.webhooks_api_key= 'XXXX'`

Please refer to the README.md under the section "webhooks" for more information on how to use the 
new webhook engine

## Master (Unreleased)

If you're upgrading from previous versions, you *must* add the following to
your `app/views/layouts/application.html.erb` before the closing of the `<head>`
tag or your credit card form will no longer work:

    <%= yield :koudoku %>
    
If you have a Haml layout file, it is:

    = yield :koudoku

## Version 0.0.9

Adding support for non-monthly plans. The default is still monthly. To
accommodate this, a `interval` attribute has been added to the `Plan` class.
To upgrade earlier installations, you can run the following commands:

    $ rails g migration add_interval_to_plan interval:string
    $ rake db:migrate
    
You'll also need to make this attribute mass-assignable:

    class Plan < ActiveRecord::Base
      include Koudoku::Plan
      attr_accessible :interval
    end
