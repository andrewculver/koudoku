require 'bluecloth'
module Koudoku
  class Engine < ::Rails::Engine
    isolate_namespace Koudoku
  end
end
