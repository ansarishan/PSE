@javascript
Feature: An Admin can view the user list

Background:

Scenario: Admin invites Org Admin
  Given I log in as an admin
   When I visit '/userlist'
   Then I should see 'System User List'

