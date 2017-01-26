# Capybara::Guides

Manually producing screenshots for user guides is time-consuming.

This gem automates the production of simple guides from Capybara feature specs, so that simple guides can be updated every time the spec is run.

This is currently a proof-of-concept, and hasn't been tested in practice yet.

## Example
Spec code
```ruby
  scenario "How to purchase a product", js: true do
    @guide.intro = "An example guide showing how to get through checkout"

    visit "/products/example_product"

    step "Add a product to your cart" do
      click_button("Add To Cart")
    end

    step "Review your cart" do
      visit "/cart"
      click_button("Checkout")
    end

    step "Enter an email address" do
      within "#guest_checkout" do
        fill_in("Email", with: "guest@example.com")
        click_button "Continue"
      end
    end

    step "Fill in your billing address" do
      within "#billing" do
        fill_in("First Name", with: "Test")
        fill_in("Last Name", with: "Test")
        fill_in("Street Address", with: "13820 NE Airport Way")
        fill_in("City", with: "Portland")
        select "United States of America", from: "order_bill_address_attributes_country_id"
        select "Alabama", from: "order_bill_address_attributes_state_id"
        fill_in("Zip", with: "97206")
        fill_in("Phone", with: "12345")
      end
      within "#shipping" do
        check "order_use_billing"
      end
      click_button("Save and Continue")
    end

    step "Choose a shipping method" do
      within "#methods" do
        choose "Shipping Method 1"
      end
      click_button("Save and Continue")
    end

    step "Enter payment details" do
      within "#payment" do
        choose "Payment Method 1"
        fill_in("Name on card", with: "Test Test")
        fill_in("Card Number", with: "4111111111111111")
        fill_in("Expiration", with: "01/99")
        fill_in("Card Code", with: "123")
      end
      click_button("Save and Continue")
    end

    step "Confirm your order" do
      expect(page).to have_content("Confirm".upcase)
      click_button("Place Order")
    end

    step "Done!" do
    end
  end
```
will be rendered...

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
