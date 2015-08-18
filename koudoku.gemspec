$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "koudoku/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "koudoku"
  s.version     = Koudoku::VERSION
  s.authors     = ["Andrew Culver"]
  s.email       = ["andrew.culver@gmail.com"]
  s.homepage    = "http://github.com/andrewculver/koudoku"
  s.summary     = %q{Robust subscription support for Rails with Stripe.}
  s.description = %q{Robust subscription support for Rails with Stripe. Provides package levels, coupons, logging, notifications, etc.}
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
  s.add_dependency "stripe"
  s.add_dependency "stripe_event"

  s.add_development_dependency "jquery-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", ">= 3.0.0"
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'pry'

  s.post_install_message = <<-EOS
Koudoku is still in early development, so if this installation is an upgrade
from an earlier version, be sure to check the CHANGELOG for any instructions
you may need to follow to accommodate breaking changes:

https://github.com/andrewculver/koudoku/blob/master/CHANGELOG.md

EOS


end
