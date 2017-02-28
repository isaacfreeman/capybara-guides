require 'mini_magick'

module Capybara
  module Guides
    class Expected
      include Screenshotable

      attr_reader :text
      attr_reader :image_filename

      def initialize(directory_name, text, element)
        @text = text
        @element = element
        @directory_name = directory_name
        @image_filename = directory_name.join('images', screenshot_filename + '.png')
        save_screenshot(image_filename)
      end

      def screenshot_filename
        @filename ||= "#{index}-expected-#{@text.parameterize(separator: '_')}".first(32)
      end

      def partial
        'capybara/guides/steps/expected'
      end
    end
  end
end
