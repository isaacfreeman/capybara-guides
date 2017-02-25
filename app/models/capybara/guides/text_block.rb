module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    # Represents a user action within a step
    class TextBlock
      # TODO: Should only need to write these
      attr_reader :text

      # TODO: Make action responsible for taking its own screenshots

      def initialize(text)
        @text = text
      end

      def partial
        'capybara/guides/steps/text_block'
      end
    end
  end
end
