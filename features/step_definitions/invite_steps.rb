When("I invite a new OrgAdmin") do
  @invite_org_admin_email = 'invite_org_admin_email@example.com'
  fill_in 'Email', with: @invite_org_admin_email
  click_button 'Submit'
end

Then("the database will contain an OnboardingInvite for that new OrgAdmin") do
  expect(OnboardingInvite.exists?(email: @invite_org_admin_email)).to eq true
end

Then("the system will send an OrgInvite email to that new OrgAdmin") do
  expect(ActionMailer::Base.deliveries.count).to eq 1
  expect(ActionMailer::Base.deliveries.first.to.first).to eq @invite_org_admin_email
  expect(ActionMailer::Base.deliveries.first.subject).to eq OrgInviteMailer::SUBJECT
end

