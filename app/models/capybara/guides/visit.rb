require 'mini_magick'

module Capybara
  module Guides
    class Visit
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
        @filename ||= "#{index}-visit-#{@text.parameterize(separator: '_')}"
      end

      def partial
        'capybara/guides/steps/visit'
      end
    end
  end
end
