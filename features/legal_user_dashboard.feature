@javascript
Feature: Dashboard for legal users

Background:
  Given this test creates Fosamax instruments

Scenario: Dashboard works when Orders do not exist
  Given I log in as a lawyer
  When I visit '/dashboard'
  Then I should see "You do not have any pending requests"
  Then I should see "You do not have any maturing orders"
  Then I should see "You do not have any settled orders"
  Then I should see "You do not have any canceled or expired orders"

Scenario: Dashboard works when Orders exist
  Given I log in as a lawyer
  And I have an unconfirmed trade with amount 11100
  And I have a negotiating trade with amount 22200
  And I have a maturing trade with amount 33300
  When I visit '/dashboard'
  Then I should see a accepted order with trade state unconfirmed
   And I should see a legal_working order with trade state negotiating
   And I should see a legal_approved order with trade state maturing
