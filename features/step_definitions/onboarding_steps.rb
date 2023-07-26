Given("I was invited to be an Org Admin") do
  @my_invite = FactoryBot.create(:onboarding_invite)
end

Given("I follow my invite link") do
  visit @my_invite.invite_url
end

Then("I should see header {string}") do |string|
  expect(page).to have_css('h1', text: string)
end

When("I enter my new username and password and submit") do
  fill_in('Username', with: @my_invite.email[/^[^@]*/])
  fill_in('Password', with: 'Password123!')
  fill_in('Confirm Password', with: 'Password123!')
  click_button 'Next >'
end

Then("I should see the User Agreement") do
  expect(page).to have_css('div.onboardingContainer-eulaContainer')
end

When("I accept the User Agreement") do
  check 'I agree to this'
  click_button 'Next >'
end

Then(/the database should contain exactly (\d+) OnboardingInvite?/) do |n|
  expect(OnboardingInvite.count).to eq n
end

Then(/the database should contain exactly (\d+) Users?/) do |n|
  expect(User.count).to eq n
end

Then(/the database should contain exactly (\d+) Organizations?/) do |n|
  expect(Organization.count).to eq n
end

Given("I am at the Organization setup phase of onboarding") do
  org = Organization.new # yep it's empty
  @my_invite.user = User.create!(email: @my_invite.email, organization: org, role: 'org_admin', has_signed_eula: true)
  @my_invite.save!
  step 'I follow my invite link'
  visit org_onboarding_new_org_path
end

When("I fill out the Organizational Contact Information form and submit") do
  fill_in 'user_first_name', with: 'OAFirst'
  fill_in 'user_last_name', with: 'OALast'
  # email is pre-filled
  fill_in 'user_phone', with: '555 555 5555'
  fill_in 'Company Name', with: 'CompanyCorp'
  fill_in 'user_address_attributes_line1', with: 'coline1'
  fill_in 'user_address_attributes_line2', with: 'coline2'
  fill_in 'user_address_attributes_city', with: 'fruitport'
  fill_in 'user_address_attributes_state', with: 'MI'
  fill_in 'user_address_attributes_postcode', with: '49415'
  fill_in 'user_address_attributes_country', with: 'USA'
  click_button 'Next >'
end

Then("in the database my organization now has a name") do
  expect(Organization.first.name).to be_present
end

Given("I am at the Legal Contact setup phase of onboarding") do
  org = FactoryBot.create(:organization)
  @my_invite.user = User.create!(email: @my_invite.email, organization: org, role: 'org_admin', has_signed_eula: true)
  @my_invite.save!
  step 'I follow my invite link'
  visit org_onboarding_new_legal_path
end

When("I fill out the Organizational Legal Contact form and submit") do
  fill_in 'user_first_name', with: 'LegalFirst'
  fill_in 'user_last_name', with: 'LegalLast'
  fill_in 'user_email', with: 'legal@example.com'
  fill_in 'user_phone', with: '555 555 5555'
  fill_in 'user_address_attributes_line1', with: 'legalline1'
  fill_in 'user_address_attributes_line2', with: 'legalline2'
  fill_in 'user_address_attributes_city', with: 'springlake'
  fill_in 'user_address_attributes_state', with: 'MI'
  fill_in 'user_address_attributes_postcode', with: '49456'
  fill_in 'user_address_attributes_country', with: 'USA'
  click_button 'Next >'
end

Then("in the database my organization now has a legal user without a username") do
  u = @my_invite.user.organization.users.find_by(role: 'legal')
  expect(u).to be_present
  expect(u.username).to be_nil
end

Given("I am at the Trader Contact setup phase of onboarding") do
  org = FactoryBot.create(:organization)
  @my_invite.user = User.create!(email: @my_invite.email, organization: org, role: 'org_admin', has_signed_eula: true)
  @my_invite.save!
  step 'I follow my invite link'
  visit org_onboarding_new_trader_path
end

When("I fill out the Organizational Trader Contact form and submit") do
  fill_in 'user_first_name', with: 'TraderFirst'
  fill_in 'user_last_name', with: 'TraderLast'
  fill_in 'user_email', with: 'trader@example.com'
  fill_in 'user_phone', with: '555 555 5555'
  fill_in 'user_address_attributes_line1', with: 'traderline1'
  fill_in 'user_address_attributes_line2', with: 'traderline2'
  fill_in 'user_address_attributes_city', with: 'muskegon'
  fill_in 'user_address_attributes_state', with: 'MI'
  fill_in 'user_address_attributes_postcode', with: '49444'
  fill_in 'user_address_attributes_country', with: 'USA'
  click_button 'Next >'
end

Then("in the database my organization now has a trader user without a username") do
  u = @my_invite.user.organization.users.find_by(role: 'trader')
  expect(u).to be_present
  expect(u.username).to be_nil
end

Given("I am at the Analyst Contact setup phase of onboarding") do
  org = FactoryBot.create(:organization)
  @my_invite.user = User.create!(email: @my_invite.email, organization: org, role: 'org_admin', has_signed_eula: true)
  @my_invite.save!
  step 'I follow my invite link'
  visit org_onboarding_new_analyst_path
end

When("I fill out the Organizational Analyst Contact form and submit") do
  fill_in 'user_first_name', with: 'AnaFirst'
  fill_in 'user_last_name', with: 'AnaLast'
  fill_in 'user_email', with: 'analyst@example.com'
  fill_in 'user_phone', with: '555 555 5555'
  fill_in 'user_address_attributes_line1', with: 'analystline1'
  fill_in 'user_address_attributes_line2', with: 'analystline2'
  fill_in 'user_address_attributes_city', with: 'grandhaven'
  fill_in 'user_address_attributes_state', with: 'MI'
  fill_in 'user_address_attributes_postcode', with: '49417'
  fill_in 'user_address_attributes_country', with: 'USA'
  click_button 'Next >'
end

Then("in the database my organization now has a analyst user without a username") do
  u = @my_invite.user.organization.users.find_by(role: 'analyst')
  expect(u).to be_present
  expect(u.username).to be_nil
end

Then("in the database my onboarding is complete") do
  @my_invite.user.reload
  expect(@my_invite.user.onboarded?).to be true
end

When("I skip this form") do
  click_button 'Skip >'
end

Then("in the database my organization should not have a analyst user") do
  expect(@my_invite.user.organization.users.where(role: 'analyst').count).to eq 0
end

