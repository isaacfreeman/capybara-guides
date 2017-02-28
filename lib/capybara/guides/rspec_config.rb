RSpec.configure do |config|
  config.include Capybara::Guides

  # set :guide automatically for guides directory
  config.define_derived_metadata(file_path: /spec[\\\/]guides[\\\/]/) do |metadata|
    metadata[:guide] = true
  end

  config.around(:each, :guide) do |example|

    @guide = Capybara::Guides::Guide.new(example)
    RSpec.current_example.metadata[:current_guide] = @guide
    example.run
    @guide.write_to_html
  end
end
