require 'mini_magick'

module Capybara
  module Guides
    class Expected
      attr_reader :text
      attr_reader :image_filename

      def initialize(directory_name, content, actual)
        # TODO: If the content is a page, mark it up as a full screenshot, otherwise as an element screenshot
        @text = content
        @element = actual
        @directory_name = directory_name
        @image_filename = directory_name.join('images', screenshot_filename + '.png')
        save_screenshot(image_filename)
      end

      def save_screenshot(image_filename)
        session.driver.save_screenshot(image_filename)
        return if full_screenshot?
        image = MiniMagick::Image.open(image_filename)
        image.crop "#{element_data['width']}x#{element_data['height']}+#{element_data['left']}+#{element_data['top']}"
        image.trim "+repage"
        image.write image_filename
      end

      def screenshot_filename
        @filename ||= "#{index}-expected-#{@text.parameterize(separator: '_')}"
      end

      # TODO: Use element class
      def full_screenshot?
        @element.is_a? Capybara::Session
      end

      def partial
        'capybara/guides/steps/expected'
      end

      private

      def index
        Dir[File.join(@directory_name, '**', '*')].count { |file| File.file?(file) } + 1
      end

      def element_data
        session.evaluate_script("document.evaluate('#{@element.path}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.getBoundingClientRect()")
      end

      def session
        return @element if @element.is_a? Capybara::Session
        @element.session
      end
    end
  end
end
