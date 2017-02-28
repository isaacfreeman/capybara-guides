module Capybara
  module Guides
    module Screenshotable
      require 'mini_magick'

      # TODO: Some elements are outside the screenshot area
      def save_screenshot(image_filename)
        session.driver.save_screenshot(image_filename, full: true)
        crop(image_filename) unless full_screenshot?
      end

      def full_screenshot?
        @element.is_a? Capybara::Session
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

      def crop(image_filename)
        image = MiniMagick::Image.open(image_filename)
        image.crop "#{element_data['width']}x#{element_data['height']}+#{element_data['left']}+#{element_data['top']}"
        image.write image_filename
      end
    end
  end
end
