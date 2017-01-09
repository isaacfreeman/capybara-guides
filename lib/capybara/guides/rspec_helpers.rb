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

    # TODO: Represent user actions like button clicks
  end
end

RSpec.configure do |config|
  config.include Capybara::Guides
  # set :guide automatically for guides directory
  config.define_derived_metadata(file_path: /spec[\\\/]guides[\\\/]/) do |metadata|
    metadata[:guide] = true
  end
  config.around(:each, :guide) do |example|
    @guide = Capybara::Guides::Guide.new(example.metadata[:description])
    example.run
    @guide.write_to_html
  end
end
