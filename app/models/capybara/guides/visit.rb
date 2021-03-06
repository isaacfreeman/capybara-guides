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
        # TODO: Manage gem versions for different Rails versions
        if Rails.version >= '5.1.0'
          @filename ||= "#{index}-visit-#{@text.parameterize(separator: '_')}"
        else
          @filename ||= "#{index}-visit-#{@text.parameterize('_')}"
        end
      end

      def partial
        'capybara/guides/steps/visit'
      end
    end
  end
end
