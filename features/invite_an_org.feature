@javascript
Feature: An Admin can manage OrgAdmin invites

Background:

Scenario: Admin invites Org Admin
  Given I log in as an admin
   When I visit '/invites/new'
    And I invite a new OrgAdmin
   Then the database will contain an OnboardingInvite for that new OrgAdmin
    And the system will send an OrgInvite email to that new OrgAdmin

