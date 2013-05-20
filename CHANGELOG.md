## Version 0.0.9

Adding support for non-monthly plans. The default is still monthly. To
accommodate this, a `interval` attribute has been added to the `Plan` class.
To upgrade earlier installations, you can run the following commands:

    $ rails g migration add_interval_to_plan interval:string
    $ rake db:migrate
    
You'll also need to make this attribute mass-assignable:

    class Plan < ActiveRecord::Base
      attr_accessible :interval
    end
