module Capybara
  module Guides
    module Screenshotable
      require 'mini_magick'

      def save_screenshot(image_filename)
        ensure_image_directory_is_present(image_filename)
        # TODO: fail gracefully if driver doesn't support save_screenshot
        session.driver.save_screenshot(image_filename, full: true)
        crop(image_filename) unless full_screenshot?
      end

      def full_screenshot?
        @element.is_a? Capybara::Session
      end

      private

      def ensure_image_directory_is_present(image_filename)
        FileUtils.mkdir_p image_filename.dirname
      end

      def index
        Dir[File.join(@directory_name, '**', '*')].count { |file| File.file?(file) } + 1
      end

      def element_data
        session.evaluate_script("document.evaluate('#{@element.path}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.getBoundingClientRect()")
      end

      def device_pixel_ratio
        session.evaluate_script("window.devicePixelRatio")
      end

      def session
        return @element if @element.is_a? Capybara::Session
        @element.session
      end

      def crop(image_filename)
        image = MiniMagick::Image.open(image_filename)
        dpr = device_pixel_ratio
        image.crop "#{element_data['width'] * dpr}x#{element_data['height'] * dpr}+#{element_data['left'] * dpr}+#{element_data['top'] * dpr}"
        image.write image_filename
      end
    end
  end
end
