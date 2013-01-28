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

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.11"
  s.add_dependency "bluecloth"

  s.add_development_dependency "sqlite3"
end
