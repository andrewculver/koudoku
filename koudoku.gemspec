# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "koudoku/version"

Gem::Specification.new do |s|
  s.name        = "koudoku"
  s.version     = Koudoku::VERSION
  s.authors     = ["Andrew Culver"]
  s.email       = ["andrew.culver@gmail.com"]
  s.homepage    = "http://github.com/andrewculver/koudoku"
  s.summary     = %q{Robust subscription support for Rails with Stripe.}
  s.description = %q{Provides package levels, coupons, logging, notifications, etc.}

  s.rubyforge_project = "koudoku"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails"
  
end
