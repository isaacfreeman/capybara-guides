# TODO: Split this file up
module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    def text_block(text)
      @guide.new_steps << TextBlock.new(text)
    end

    def heading(text)
      @guide.new_steps << Heading.new(text)
    end

    def screenshot
      return unless page.current_path.present?
      @guide.new_steps << Capybara::Guides::Screenshot.new(@guide.directory_name, self)
    end
  end
end

# Override Capybara actions to record actions taken
module RecordGuideActionForCapybaraActions
  # TODO: attach_file(locator, path, options = {})

  def check(locator, options = {})
    record_action "Check \"#{locator}\""
    super
  end

  def choose(locator, options = {})
    record_action "Choose \"#{locator}\""
    super
  end

  def click_button(locator = nil, options = {})
    record_action "Click the \"#{locator}\" button"
    super
  end

  def click_link(locator = nil, options = {})
    record_action "Click on \"#{locator}\""
    super
  end

  def click_link_or_button(locator = nil, options = {})
    link_or_button = find(:link_or_button, locator, options)
    record_action "Click on \"#{locator}\"#{at_position(link_or_button)}"
    super
  end
  alias_method :click_on, :click_link_or_button

  def fill_in(locator, options = {})
    record_action "Fill in #{locator} with \"#{options[:with]}\""
    super
  end

  def select(value, options = {})
    record_action "Select \"#{value}\" from #{options[:from]}"
    super
  end

  def uncheck(locator, options = {})
    record_action "Uncheck \"#{locator}\""
    super
  end

  def unselect(value, options = {})
    record_action "Unselect \"#{value}\" from #{options[:from]}"
    super
  end

  private

  # TODO: Merge with user_action
  def record_action(text)
    guide = RSpec.current_example.metadata[:current_guide]
    guide.new_steps << Capybara::Guides::Action.new(text) if guide.present?
  end

  def at_position(element)
    xpath = element.path
    element_data = @session.evaluate_script("document.evaluate('#{xpath}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.getBoundingClientRect()")
    body_data = @session.evaluate_script("document.body.getBoundingClientRect()")
    top_limit = body_data['height']/3
    bottom_limit = body_data['height']*2/3
    vertical_position = case element_data['top']
                        when 0..top_limit then 'top'
                        when top_limit..bottom_limit then 'center'
                        else 'bottom'
                        end
    left_limit = body_data['width']/3
    right_limit = body_data['width']*2/3
    horizontal_position = case element_data['left']
                          when 0..left_limit then 'left'
                          when left_limit..right_limit then 'middle'
                          else 'right'
                          end
    position = [vertical_position, horizontal_position].join(' ')
    return " in the middle" if position == 'middle center'
    " at the #{position}"
  end
end
Capybara::Node::Base.prepend RecordGuideActionForCapybaraActions

# Override Capybara visit action to record the action
module RecordGuideActionForVisit
  def visit(visit_uri)
    guide = RSpec.current_example.metadata[:current_guide]
    if guide.present?
      text = "Visit #{visit_uri}"
      guide.new_steps << Capybara::Guides::Action.new(text) if guide.present?
    end
    super
  end
end
Capybara::Session.prepend RecordGuideActionForVisit

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

# TODO: Screenshots for other RSpec matchers
module RecordScreenshotForHaveTextMatch
  def matches?(actual)
    guide = RSpec.current_example.metadata[:current_guide]
    guide.new_steps << Capybara::Guides::Expected.new(guide.directory_name, content, actual) if guide.present?
    super
  end
end
Capybara::RSpecMatchers::HaveText.prepend RecordScreenshotForHaveTextMatch
