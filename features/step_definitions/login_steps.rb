Given("I am an existing admin user") do
  @active_user = User.find_by(role: 'admin') || FactoryBot.create(:admin)
end

When("I visit the sign-in page") do
  visit '/users/sign_in'
end

When("I enter my username and password and submit") do
  fill_in 'user_username', with: @active_user.username
  fill_in 'user_password', with: 'Password123!'
  click_button 'Login'
end

Then("I should be logged in") do
  expect(page).to have_css('#usernameMenuOpener')
end

Then("I should be at my dashboard") do
  expect(current_url).to include('dashboard')
end

When("I click logout in the user menu") do
  click_on 'usernameMenuOpener'
  click_on 'logoutLink'
end

Then("I should be logged out") do
  expect(page).to have_content('Signed out successfully')
end

Given /^I log in as an? ([a-z_]+)$/ do |user_role|
  if user_role=='admin'
    @active_user = User.find_by(role: 'admin') || FactoryBot.create(:admin)
  else
    if @active_organization
      @active_user = @active_organization.users.find_by(role: user_role) ||
        FactoryBot.create(user_role.intern, organization: @active_organization)
    else
      @active_user = FactoryBot.create(user_role.intern)
      @active_organization = @active_user.organization
    end
  end
  visit '/users/sign_in'
  fill_in 'user_username', with: @active_user.username
  fill_in 'user_password', with: 'Password123!'
  click_button 'Login'
end
