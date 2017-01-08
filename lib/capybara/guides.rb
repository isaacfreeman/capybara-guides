require 'capybara/guides/version'
require 'fileutils'

module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    # TODO: Assume :guide tag if spec is in spec/guides

    def step(title = nil)
      current_step = Step.new(self, @guide.steps.size + 1, title)
      yield
      current_step.save_guide_screenshot
      @guide.steps << current_step
    end

    # Represents a user guide
    class Guide
      attr_accessor :steps
      attr_writer :intro

      def initialize(title = nil)
        @title = title
        @steps = []
      end

      # TODO: Use a layout and partial for HTML
      #       See http://blog.bigbinary.com/2016/01/08/rendering-views-outside-of-controllers-in-rails-5.html
      def write_to_html
        # rendered_string = ApplicationController.render(
        #   template: 'users/show',
        #   assigns: { steps: @steps }
        # )
        directory_name = Rails.root.join('doc/guides')
        path = directory_name.join('guide.html')
        puts "Writing guide to #{path}"
        file_html = File.new(path, 'w+')
        file_html.puts '<html><head></head><body><ol>'
        file_html.puts "<h1>#{@title}</h1>"
        file_html.puts "<p>#{@intro}</p>"
        @steps.each do |step|
          file_html.puts "<li><h3>#{step.title}</h3>"
          file_html.puts "<img src='#{step.screenshot_name}' ></li>"
        end
        file_html.puts '</ol></body></html>'
        file_html.close
      end
    end

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

RSpec.configure do |config|
  config.include Capybara::Guides
  config.around(:each, :guide) do |example|
    @guide = Capybara::Guides::Guide.new(example.metadata[:description])
    example.run
    @guide.write_to_html
  end
end
