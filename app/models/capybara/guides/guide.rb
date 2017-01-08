require 'fileutils'

module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    # Represents a user guide
    class Guide
      attr_accessor :steps
      attr_accessor :intro
      attr_accessor :title

      def initialize(title = nil)
        @title = title
        @steps = []
      end

      # TODO: Use title instead of "guide.html"
      # TODO: Config for destination path
      def write_to_html
        rendered_string = GuidesController.render(
          layout: 'capybara/guides/guides',
          template: 'capybara/guides/show',
          assigns: { guide: self }
        )
        directory_name = Rails.root.join('doc/guides')
        path = directory_name.join('guide.html')
        puts "Writing guide to #{path}"
        file_html = File.new(path, 'w+')
        file_html.puts rendered_string
        file_html.close
      end
    end
  end
end
