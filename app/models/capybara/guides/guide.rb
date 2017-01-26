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

      # TODO: Config for destination path
      # TODO: Write CSS file into directory
      def write_to_html
        rendered_string = GuidesController.render(
          layout: 'capybara/guides/guides',
          template: 'capybara/guides/show',
          assigns: { guide: self }
        )
        directory_name = Rails.root.join('doc/guides')
        path = directory_name.join(html_filename(title))
        puts "Writing guide to #{path}"
        file_html = File.new(path, 'w+')
        file_html.puts rendered_string
        file_html.close
      end

      private

      def html_filename(title)
        ActiveSupport::Inflector.transliterate(
          title.downcase.gsub(/\s/,"_")
        ) + '.html'
      end
    end
  end
end
