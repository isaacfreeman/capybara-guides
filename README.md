# Capybara::Guides

Manually producing screenshots for user guides is time-consuming.

This gem automates the production of simple guides from Capybara feature specs, so that simple guides can be generated automatically every time the spec is run.

This is currently a proof-of-concept, and hasn't been tested in practice yet.

![Example Image](https://raw.githubusercontent.com/isaacfreeman/capybara-guides/master/doc/example.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capybara-guides'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-guides

## Usage
Add the `:guide` tag to the scenario you want to generate a guide from. If you have `infer_spec_type_from_file_location!` active, you can also put your guide specs directly into `/spec/guides`.

Add an optional intro.
```
scenario "How to purchase a product", js: true, guide: true do
  @guide.intro = "An example guide showing how to get through checkout"
  ...
end
```

Add `step` blocks to surround each section of RSpec code you'd like to be represented in the guide. A screenshot will be taken when the step is completed.
```
step "Add a product to your cart" do
  visit "/products/example_product"
end
```

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/isaacfreeman/capybara-guides. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
