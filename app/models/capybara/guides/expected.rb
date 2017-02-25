require 'mini_magick'

module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    # Represents a user action within a step
    class Expected
      attr_reader :text
      attr_reader :image_filename

      # TODO: Make Expected responsible for taking its own screenshots

      def initialize(directory_name, content, actual)
        @text = content
        @directory_name = directory_name
        @image_filename = directory_name.join('images', screenshot_filename + '.png')
        save_screenshot(image_filename, actual)
      end

      def save_screenshot(image_filename, actual)
        actual.session.driver.save_screenshot(image_filename)
        xpath = actual.path
        element_data = actual.session.evaluate_script("document.evaluate('#{xpath}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.getBoundingClientRect()")
        image = MiniMagick::Image.open(image_filename)
        image.crop "#{element_data['width']}x#{element_data['height']}+#{element_data['left']}+#{element_data['top']}"
        image.trim "+repage"
        image.write image_filename
      end

      def screenshot_filename
        @filename ||= "#{index}-expected-#{@text.parameterize(separator: '_')}"
      end

      def partial
        'capybara/guides/steps/expected'
      end

      private

      def index
        Dir[File.join(@directory_name, '**', '*')].count { |file| File.file?(file) } + 1
      end
    end
  end
end
