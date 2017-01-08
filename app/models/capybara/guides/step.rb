module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    # Represents a single step within a guide
    class Step
      attr_reader :title

      def initialize(capybara_example_group, index, title = nil)
        @title = title
        @index = index
        @capybara_example_group = capybara_example_group
      end

      def save_guide_screenshot
        directory_name = Rails.root.join('doc/guides')
        FileUtils.mkdir_p(directory_name)
        path = directory_name.join(screenshot_name)
        @capybara_example_group.save_screenshot(path, full: true)
      end

      def screenshot_name
        "screenshot_#{@index}.png"
      end
    end
  end
end
