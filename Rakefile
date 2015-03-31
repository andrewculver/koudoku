#!/usr/bin/env rake
require "bundler/gem_tasks"

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(spec: 'app:db:test:prepare')

task default: :spec
