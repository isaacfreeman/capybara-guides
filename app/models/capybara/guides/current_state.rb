require 'mini_magick'

module Capybara
  module Guides
    class CurrentState < Expected
      def partial
        'capybara/guides/steps/current_state'
      end
    end
  end
end
