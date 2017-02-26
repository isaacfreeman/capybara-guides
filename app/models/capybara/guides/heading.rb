module Capybara
  module Guides
    class Heading
      attr_reader :text

      def initialize(text)
        @text = text
      end

      def partial
        'capybara/guides/steps/heading'
      end
    end
  end
end
