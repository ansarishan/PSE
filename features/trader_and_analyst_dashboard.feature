@javascript
Feature: Dashboard for traders and analysts

Background:
  Given this test creates Fosamax instruments

Scenario Outline: Dashboard works when Orders do not exist
  Given I log in as a <user_role>
  When I visit '/dashboard'
  Then I should see "You do not have any open orders"
  And I should see "You do not have any orders with a pending match"
  And I should see "You do not have any maturing orders"
  And I should see "You do not have any settled orders"
  And I should see "You do not have any canceled or expired orders"

  Examples:
    | user_role |
    | trader    |
    | analyst   |

Scenario Outline: Dashboard works when Orders exist
  Given I log in as a <user_role>
  And I have an open order with amount 11100
  And I have an unconfirmed trade with amount 22200
  And I have a negotiating trade with amount 33300
  And I have a maturing trade with amount 44400
  When I visit '/dashboard'
  Then I should see an order with amount 11100
  Then I should see an order with amount 22200
  Then I should see an order with amount 33300
  Then I should see an order with amount 44400

  Examples:
    | user_role |
    | trader    |
    | analyst   |
