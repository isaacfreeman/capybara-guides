module Capybara
  module Guides
    class TextBlock
      attr_reader :text

      def initialize(text)
        @text = text
      end

      def partial
        'capybara/guides/steps/text_block'
      end
    end
  end
end
