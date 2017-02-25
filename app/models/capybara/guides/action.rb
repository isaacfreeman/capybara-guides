module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    # Represents a user action
    class Action
      attr_reader :text
      attr_reader :result_text
      attr_reader :result_image_filename

      # TODO: Make action responsible for taking its own screenshots

      def initialize(text, result_text = nil, result_image_filename = nil)
        @text = text
        @result_text = result_text
        @result_image_filename = result_image_filename
      end

      def partial
        'capybara/guides/steps/action'
      end
    end
  end
end
