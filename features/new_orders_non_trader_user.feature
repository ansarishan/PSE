@javascript
Feature: Non-traders cannot submit orders

Scenario: Analyst cannot submit orders
  Given this test creates Fosamax instruments
    And I log in as an analyst
   When I visit the first Fosamax book
   Then I should not be able to open an order ticket
