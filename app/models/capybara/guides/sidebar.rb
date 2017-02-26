module Capybara
  module Guides
    class Sidebar
      attr_reader :text

      def initialize(text)
        @text = text
      end

      def partial
        'capybara/guides/steps/sidebar'
      end
    end
  end
end
