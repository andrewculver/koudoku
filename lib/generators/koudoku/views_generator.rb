# this generator based on rails_admin's install generator.
# https://www.github.com/sferik/rails_admin/master/lib/generators/rails_admin/install_generator.rb

require 'rails/generators'

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html

module Koudoku
  class ViewsGenerator < Rails::Generators::Base

    # Not sure what this does.
    source_root File.expand_path("../../../../app/views/koudoku/subscriptions", __FILE__)

    include Rails::Generators::Migration

    desc "Koudoku installation generator"

    def install
      
      ["_pricing_table.html.erb", "edit.html.erb", "index.html.erb", "new.html.erb", "show.html.erb"].each do |file|
        copy_file file, "app/views/koudoku/subscriptions/#{file}"
      end

    end

  end
end