# Capybara::Guides

Manually producing screenshots for user guides is time-consuming.

This gem automates the production of simple guides from Capybara feature specs, so that simple guides can be updated every time the spec is run.

This is currently a proof-of-concept, and hasn't been tested in practice yet.

## Example
Here's an example `scenario` block from a feature spec using Rspec and Capybara, where an admin is creating an order in the [Solidus](https://github.com/solidusio/solidus) eCommerce platform.
```ruby
scenario "Admin is manually creating an order", js: true do
  text_block <<~HEREDOC.html_safe
    <h3>Introduction</h3>
    This guide covers how to create a manual order from the Admin Interface.
  HEREDOC

  heading "Create a New Order"
  visit spree.admin_path
  click_on "Orders"
  click_on "New Order"

  heading "Add Products to the Order"
  expect(page).to have_text('Cart')
  expect(first('fieldset')).to have_text('Add Product')
  select2_search product.name, from: Spree.t(:name_or_sku)
  expect(page).to have_text('Select stock')
  fill_in_quantity("table.stock-levels", "quantity_0", 2)
  click_button 'Add'
  sidebar "Follow the same steps to add more products to the order"

  heading "Add Customer Details"
  click_on "Customer"
  expect(page).to have_text('Customer Details')
  within "#select-customer" do
    targetted_select2_search user.email, from: "#s2id_customer_search"
  end
  sidebar <<~HEREDOC
    You can either select a name from the "Customer Search" field if the customer has ordered from you before, or you can enter the customer's email address in the "Email" field of the "Account" section. The setting for "Guest Checkout" will automatically change accordingly."
  HEREDOC
  check "order_use_billing"
  fill_in "First Name",                with: "John 99"
  fill_in "Last Name",                 with: "Doe"
  fill_in "Street Address",            with: "100 first lane"
  fill_in "Street Address (cont'd)",   with: "#101"
  fill_in "City",                      with: "Bethesda"
  fill_in "Zip",                       with: "20170"
  targetted_select2_search state.name, from: "#s2id_order_bill_address_attributes_state_id"
  fill_in "Phone",                     with: "123-456-7890"
  click_on "Update"

  heading "Shipments"
  expect(page).to have_text('Shipments')

  heading "Adjustments"
  click_on "Adjustments"
  expect(page).to have_text('Adjustments')

  heading "Payments"
  click_on "Payments"
  expect(page).to have_text('Payments')
  click_on "Update"

  heading "Confirm"
  click_on "Confirm"
  expect(page).to have_text('Confirm Order')
  click_on "Complete Order"

  heading "Done"
  expect(page).to have_text('Order completed')
end

```
As the spec is run, capybara-guides records what actions were taken, and saves screenshots at relevant points. AT the end, it produces static HTML reproducing the spec as a human-readable recipe for reproducing the same steps:

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

```ruby
scenario "How to purchase a product", js: true, guide: true do
  ...
end
```

Add calls to the `heading`, `text_block` and `sidebar` methods as needed.
```ruby
heading "Create a New Order"

text_block "This guide covers how to create a manual order from the Admin Interface."

sidebar "The setting for \"Guest Checkout\" will automatically change accordingly."
```

Browser links, buttons and form elements will be captured as images when the relevant Capybara methods are called (e.g. click_button, fill_in, choose, select...)

Additional images will be captured for each use of the Capybara `HaveText` matcher.
```ruby
expect(find('.header')).to have_text('Some Text')  # ...will capture a particular page element

expect(page).to have_text('Some Text')             # ...will capture a screenshot of the full page
```

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/isaacfreeman/capybara-guides. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
