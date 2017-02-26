require 'mini_magick'

module Capybara
  module Guides
    class Action
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

      # TODO: Extract screenshot code to a module
      # TODO: Some elements are outside the screenshot area
      def save_screenshot(image_filename)
        session.driver.save_screenshot(image_filename, full: true)
        crop(image_filename) unless full_screenshot?
      end

      def screenshot_filename
        @filename ||= "#{index}-action-#{@text.parameterize(separator: '_')}".first(32)
      end

      def full_screenshot?
        @element.is_a? Capybara::Session
      end

      def partial
        'capybara/guides/steps/action'
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
