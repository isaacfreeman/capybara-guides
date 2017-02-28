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
