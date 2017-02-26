module Capybara
  module Guides
    class Action
      attr_reader :text
      attr_reader :result_text
      attr_reader :result_image_filename

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
