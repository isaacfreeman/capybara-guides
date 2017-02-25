module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    def step(title = nil)
      @current_step = Step.new(@guide.directory_name, self, @guide.steps.size + 1, title)
      RSpec.current_example.metadata[:current_step] = @current_step
      @current_step.save_guide_screenshot if page.current_path.present?
      @guide.steps << @current_step
      yield
      @current_step = nil
      RSpec.current_example.metadata[:current_step] = nil
    end

    def user_action(text)
      @current_step.actions << text
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
  def record_action(action)
    if RSpec.current_example.metadata[:current_guide].present?
      current_step = RSpec.current_example.metadata[:current_step]
      current_step.actions << action if current_step.present?
    end
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
    if RSpec.current_example.metadata[:current_guide].present?
      current_step = RSpec.current_example.metadata[:current_step]
      current_step.actions << "Visit #{visit_uri}" if current_step.present?
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
