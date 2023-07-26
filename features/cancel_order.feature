@javascript
Feature: Trader can cancel orders

Background:
  Given this test creates Fosamax instruments
    And I log in as a trader

Scenario: Order is canceled via the dashboard
   Given my organization has an open up order for 9787950 in the first Fosamax instrument
    When I visit '/dashboard'
     And I click the cancel icon for the first-listed order
     And I accept the confirmation dialog
    Then I should see "Order canceled."
     And the database should not have any open orders

Scenario: Via the dashboard, order is not canceled because confirmation dialog is dismissed
   Given my organization has an open up order for 8675300 in the first Fosamax instrument
    When I visit '/dashboard'
    When I click the cancel icon for the first-listed order
     And I dismiss the confirmation dialog
     Then I should not see "Order canceled."
      And the database should have my open up order for 8675300

Scenario Outline: Order is canceled via the book
  Given my organization has an open <side> order for 2682750 in the first Fosamax instrument
    And I visit the first Fosamax book
   When I click the cancel icon for the open <side> order
    And I accept the confirmation dialog
   Then I should see "Order canceled."
    And the database should not have any open orders

  Examples:
    | side |
    | up   |

Scenario Outline: Via the book, order is not canceled because confirmation dialog is dismissed
  Given my organization has an open <side> order for 2643150 in the first Fosamax instrument
    And I visit the first Fosamax book
   When I click the cancel icon for the open <side> order
    And I dismiss the confirmation dialog
   Then I should not see "Order canceled."
    And the database should have my open <side> order for 2643150

  Examples:
    | side |
    | up   |
    | down |

