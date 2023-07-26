@javascript
Feature: A Legal user can start negotiation of an unconfirmed trade

Background:
  Given this test creates Fosamax instruments
  And I log in as a lawyer
  And I have an unconfirmed trade with amount 11100

Scenario: Order is placed into Legal Working status
    When I visit '/dashboard'
     And I click the View link for the first unconfirmed trade
     And I click Start Contract
     And I accept the confirmation dialog
    Then I should see "Contract started."
     And the database should have my legal_working up order for 11100 and its negotiating trade
