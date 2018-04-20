module Capybara
  # Classes to support generating guides in Capybara feature specs
  module Guides
    def text_block(text)
      @guide.steps << TextBlock.new(text)
    end

    def user_action(text)
      @guide.steps << UserAction.new(text)
    end

    def user_action(text, element: nil)
      @guide.steps << Capybara::Guides::UserAction.new(text, element, @guide.directory_name)
    end

    def heading(text)
      @guide.steps << Heading.new(text)
    end

    def sidebar(text)
      @guide.steps << Sidebar.new(text)
    end
  end
end
