module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    def text_block(text)
      @guide.steps << TextBlock.new(text)
    end

    def heading(text)
      @guide.steps << Heading.new(text)
    end

    def sidebar(text)
      @guide.steps << Sidebar.new(text)
    end
  end
end

# Override Capybara actions to record actions taken
module RecordGuideActionForCapybaraActions
  # TODO: attach_file(locator, path, options = {})

  def check(locator, options = {})
    super
    target = find(:checkbox, locator, options).first(:xpath, ".//..")
    text = "Check <samp>#{locator}</samp>".html_safe
    record_action text, target
  end

  def choose(locator, options = {})
    super
    target = find(:radio_button, locator, options).first(:xpath, ".//..")
    text = "Choose <samp>#{locator}</samp>".html_safe
    record_action text, target
  end

  def click_button(locator = nil, options = {})
    target = find(:link_or_button, locator, options)
    text = "Click the <samp>#{locator}</samp> button".html_safe
    record_action text, target
    super
  end

  def click_link(locator = nil, options = {})
    target = find(:link_or_button, locator, options)
    text = "Click the <samp>#{locator}</samp> link".html_safe
    record_action text, target
    super
  end

  def click_link_or_button(locator = nil, options = {})
    target = find(:link_or_button, locator, options)
    tag_type = target.tag_name == 'button' ? 'button' : 'link'
    text = "Click the <samp>#{locator}</samp> #{tag_type}#{at_position(target)}".html_safe
    record_action text, target
    super
  end
  alias_method :click_on, :click_link_or_button

  def fill_in(locator, options = {})
    with = options[:with]
    super
    target = find(:fillable_field, locator)
    text = "Fill in #{locator} with <kbd>#{with}</kbd>".html_safe
    record_action text, target
  end

  def select(value, options = {})
    from = options[:from]
    super
    target = find(:select, from)
    text = "Select <samp>#{value}</samp> from #{from}".html_safe
    record_action text, target
  end

  def uncheck(locator, options = {})
    super
    target = find(:checkbox, locator, options).first(:xpath, ".//..")
    text = "Uncheck <samp>#{locator}</samp>".html_safe
    record_action text, target
  end

  def unselect(value, options = {})
    from = options[:from]
    super
    target = find(:target, from)
    text = "Unselect <samp>#{value}</samp> from #{from}".html_safe
    record_action text, target
  end

  private

  def record_action(text, element = nil)
    guide = RSpec.current_example.metadata[:current_guide]
    guide.steps << Capybara::Guides::Action.new(text, element, guide.directory_name) if guide.present?
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
    super
    guide = RSpec.current_example.metadata[:current_guide]
    if guide.present?
      text = "Visit <samp>#{visit_uri}</samp>".html_safe
      guide.steps << Capybara::Guides::Visit.new(text, self, guide.directory_name) if guide.present?
    end
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

module RecordScreenshotForHaveTextMatch
  def matches?(actual)
    guide = RSpec.current_example.metadata[:current_guide]
    guide.steps << Capybara::Guides::Expected.new(guide.directory_name, content, actual) if guide.present?
    super
  end
end
Capybara::RSpecMatchers::HaveText.prepend RecordScreenshotForHaveTextMatch
