Feature: Org Admin Onboarding

Background:
  Given I was invited to be an Org Admin

Scenario: As an invited OrgAdmin, I can register and accept EULA
  Given I follow my invite link
   Then I should see header "Set Your Username + Password"
   When I enter my new username and password and submit
   Then I should see the User Agreement

   When I accept the User Agreement
   Then I should see header "Organizational Contact Information"

    And the database should contain exactly 1 User
    And the database should contain exactly 1 Organization


Scenario: As an invited OrgAdmin, I can set up my Organization
  Given I am at the Organization setup phase of onboarding
   Then I should see header "Organizational Contact Information"
   When I fill out the Organizational Contact Information form and submit
   Then I should see header "Organizational Legal Contact"

    And in the database my organization now has a name


Scenario: As an invited OrgAdmin, I can set up a Legal Contact
  Given I am at the Legal Contact setup phase of onboarding
   Then I should see header "Organizational Legal Contact"
   When I fill out the Organizational Legal Contact form and submit
   Then I should see header "Organizational Trader Contact"

    And in the database my organization now has a legal user without a username


Scenario: As an invited OrgAdmin, I can set up a Trader Contact
  Given I am at the Trader Contact setup phase of onboarding
   Then I should see header "Organizational Trader Contact"
   When I fill out the Organizational Trader Contact form and submit
   Then I should see header "Organizational Analyst Contact"

    And in the database my organization now has a trader user without a username


Scenario: As an invited OrgAdmin, I can set up a Analyst Contact
  Given I am at the Analyst Contact setup phase of onboarding
   Then I should see header "Organizational Analyst Contact"
   When I fill out the Organizational Analyst Contact form and submit
   Then I should see header "Organization Onboarding Complete"

    And in the database my organization now has a analyst user without a username
    And in the database my onboarding is complete


Scenario: As an invited OrgAdmin, I can skip setting up a Analyst Contact
  Given I am at the Analyst Contact setup phase of onboarding
   Then I should see header "Organizational Analyst Contact"
   When I skip this form
   Then I should see header "Organization Onboarding Complete"

    And in the database my organization should not have a analyst user
    And in the database my onboarding is complete

