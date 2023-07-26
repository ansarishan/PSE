@javascript
Feature: Non-trader cannot cancel orders

Scenario: Analyst cannot cancel orders
  Given this test creates Fosamax instruments
    And I log in as an analyst
    And I have an open order with amount 9787600
    When I visit '/dashboard'
    Then I should not be able to see order cancel icons
