module Capybara
  module Guides
    class Engine < ::Rails::Engine
      isolate_namespace Capybara::Guides
    end
  end
end
