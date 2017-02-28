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
