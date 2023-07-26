@javascript
Feature: Login/Logout

Background:
  Given I am an existing admin user
  And I visit the sign-in page

Scenario: I can see the login prompt
  Then I should see "Welcome Back"

Scenario: I can login and get sent to the dashboard
  When I enter my username and password and submit
  Then I should be logged in
   And I should be at my dashboard

Scenario: I can logout
  When I enter my username and password and submit
  Then I should be logged in
  When I click logout in the user menu
  Then I should be logged out

