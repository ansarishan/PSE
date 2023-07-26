Given("I visit {string}") do |string|
  visit string
end

When("I enter {string} in {string}") do |text, field|
  fill_in field, with: text
end

When("I click {string}") do |link_or_button|
  click_link_or_button link_or_button
end

Then("I should see {string}") do |content|
  expect(page).to have_content(content)
end

Then("I should not see {string}") do |content|
  expect(page).not_to have_content(content)
end

Then(/^I pry$/) do
  binding.pry
end
