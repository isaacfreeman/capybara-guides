module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    # Represents a single step within a guide
    class Step
      attr_reader :title
      attr_accessor :actions

      def initialize(directory_name, capybara_example_group, index, title = nil)
        @title = title
        @index = index
        @capybara_example_group = capybara_example_group
        @actions = []
        @directory_name = directory_name
      end

      def save_guide_screenshot
        FileUtils.mkdir_p(@directory_name)
        path = @directory_name.join('images', screenshot_filename)
        @capybara_example_group.save_screenshot(path, full: true)
      end

      def screenshot_filename
        "#{@index}-#{@title.parameterize(separator: '_')}.png"
      end
    end
  end
end
