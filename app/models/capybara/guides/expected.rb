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
        # TODO: Manage gem versions for different Rails versions
        if Rails.version >= '5.1.0'
          @filename ||= "#{index}-expected-#{@text.parameterize(separator: '_')}".first(32)
        else
          @filename ||= "#{index}-expected-#{@text.parameterize('_')}".first(32)
        end
      end

      def partial
        'capybara/guides/steps/expected'
      end
    end
  end
end
