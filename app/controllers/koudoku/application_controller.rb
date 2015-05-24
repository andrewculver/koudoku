module Koudoku
  class ApplicationController < ::ApplicationController
    layout Koudoku.layout
    helper :application
    
    # stolen from http://stackoverflow.com/questions/9232175/access-main-app-helpers-when-overridings-a-rails-engine-view-layout#comment44856124_19453140
    # to solve the problem of having to reference "main_app.$some_model_path" in layouts
    helper Rails.application.routes.url_helpers 
  end
end
