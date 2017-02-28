module RecordScreenshotForHaveTextMatch
  def matches?(actual)
    guide = RSpec.current_example.metadata[:current_guide]
    guide.steps << Capybara::Guides::Expected.new(guide.directory_name, content, actual) if guide.present?
    super
  end
end
Capybara::RSpecMatchers::HaveText.prepend RecordScreenshotForHaveTextMatch
