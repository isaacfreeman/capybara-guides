module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    # Represents a single step within a guide
    class Screenshot
      def initialize(directory_name, capybara_example_group)
        @capybara_example_group = capybara_example_group
        @directory_name = directory_name
        save_screenshot(directory_name, capybara_example_group)
      end

      def save_screenshot(directory_name, capybara_example_group)
        FileUtils.mkdir_p(directory_name)
        path = directory_name.join(relative_path)
        capybara_example_group.save_screenshot(path, full: true)
      end

      # TODO: More human-readable filenames
      def screenshot_filename
        # "#{index}-#{@title.parameterize(separator: '_')}"
        @filename ||= "#{index}-screenshot"
      end

      def relative_path
        "images/#{screenshot_filename}.png"
      end

      def partial
        'capybara/guides/steps/screenshot'
      end

      private
      
      def index
        Dir[File.join(@directory_name, '**', '*')].count { |file| File.file?(file) } + 1
      end
    end
  end
end
