@javascript

Feature: Trader can match another order

Background:
  Given this test creates Fosamax instruments
   When I log in as a trader

Scenario Outline: The trader matches an open order
  Given there is an open <side> order for 350 in the first Fosamax instrument
    And I visit the first Fosamax book
   When I use the UI to match the open <side> order
   Then the database should have my accepted <other-side> order for 350 and its unconfirmed trade
    And the lawyers on each side of the trade should receive new-order-notification emails

  Examples:
    | side | other-side |
    | up   | down       |
    | down | up         |

