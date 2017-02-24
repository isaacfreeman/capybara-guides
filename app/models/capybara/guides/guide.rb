require 'fileutils'

module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    # Represents a user guide
    class Guide
      attr_accessor :steps
      attr_accessor :intro
      attr_accessor :title

      def initialize(example)
        @group_title = example.metadata[:example_group][:description]
        @title = example.metadata[:description]
        @steps = []
      end

      # TODO: Config for destination path
      # TODO: Write CSS file into directory
      def write_to_html
        FileUtils.mkdir_p(directory_name)
        path = directory_name.join(html_filename)
        puts "Writing guide to #{path}"
        file_html = File.new(path, 'w+')
        file_html.puts rendered_string
        file_html.close
      end

      def directory_name
        group_dir = @group_title.parameterize(separator: '_')
        guide_dir = title.parameterize(separator: '_')
        Rails.root.join('doc', 'guides', group_dir, guide_dir)
      end

      def browser_title
        "#{@group_title} | #{title}"
      end

      private

      def rendered_string
        GuidesController.render(
          layout: 'capybara/guides/guides',
          template: 'capybara/guides/show',
          assigns: { guide: self }
        )
      end

      def html_filename
        'index.html'
      end
    end
  end
end
