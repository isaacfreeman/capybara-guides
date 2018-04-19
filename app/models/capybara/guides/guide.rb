require 'fileutils'

module Capybara
  module Guides
    # Represents a user guide
    class Guide
      attr_accessor :steps
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
        # TODO: Manage gem versions for different Rails versions
        if Rails.version >= '5.1.0'
          group_dir = @group_title.parameterize(separator: '_')
          guide_dir = title.parameterize(separator: '_')
        else
          group_dir = @group_title.parameterize('_')
          guide_dir = title.parameterize('_')
        end
        Rails.root.join('doc', 'guides', group_dir, guide_dir)
      end

      def browser_title
        "#{@group_title} | #{title}"
      end

      private

      def rendered_string
        # TODO: In Rails 5 we can do this:
        # GuidesController.render(
        #   layout: 'capybara/guides/guides',
        #   template: 'capybara/guides/show',
        #   assigns: { guide: self }
        # )
        assigns = { guide: self }
        view = ActionView::Base.new(GuidesController.view_paths, assigns)
        view.render(layout: 'layouts/capybara/guides/guides', template: 'capybara/guides/show')
      end

      def html_filename
        'index.html'
      end
    end
  end
end
