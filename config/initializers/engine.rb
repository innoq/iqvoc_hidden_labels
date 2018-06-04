require 'rails'

module Iqvoc
  module OeRK

    class Engine < Rails::Engine

      paths["lib/tasks"] << "lib/engine_tasks"

    end

  end
end