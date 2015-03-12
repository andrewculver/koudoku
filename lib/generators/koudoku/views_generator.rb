# this generator based on rails_admin's install generator.
# https://www.github.com/sferik/rails_admin/master/lib/generators/rails_admin/install_generator.rb

require 'rails/generators'

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html

module Koudoku
  class ViewsGenerator < Rails::Generators::Base

    # Not sure what this does.
    source_root "#{Koudoku::Engine.root}/app/views/koudoku/subscriptions"

    include Rails::Generators::Migration

    desc "Koudoku installation generator"

    def install
      
      # all entries in app/views/koudoku/subscriptions without . and .. 
      # ==> all FILES in the directory
      files_to_copy = Dir.entries("#{Koudoku::Engine.root}/app/views/koudoku/subscriptions") - %w[. ..]
      files_to_copy.each do |file|
        copy_file file, "app/views/koudoku/subscriptions/#{file}"
      end

    end

  end
end
