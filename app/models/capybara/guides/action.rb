module Capybara
  module Guides
    class Action
      include Screenshotable

      attr_reader :text
      attr_reader :image_filename

      def initialize(text, element = nil, directory_name = nil)
        @text = text
        return unless element && directory_name
        @element = element
        @directory_name = directory_name
        @image_filename = directory_name.join('images', screenshot_filename + '.png')
        save_screenshot(image_filename)
      end

      def screenshot_filename
        @filename ||= "#{index}-action-#{@text.parameterize(separator: '_')}".first(32)
      end

      def partial
        'capybara/guides/steps/action'
      end
    end
  end
end
