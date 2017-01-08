module Capybara
  module Guides
    # Ensures we have a known controller to render from
    class GuidesController < ActionController::Base
      protect_from_forgery with: :exception
    end
  end
end
