@javascript

Feature: Trader can submit orders

Background:
  Given this test creates Fosamax instruments
    And I log in as a trader
    And I visit the first Fosamax book

Scenario: The trader submits an up-side order
    When I open the up-side order ticket for the first-listed core contract
     And I submit the order ticket with amount 350
    Then the database should have an open up-side order with amount 350

Scenario: The trader submits a down-side order
   When I open the down-side order ticket for the first-listed core contract
    And I submit the order ticket with amount 750
   Then the database should have an open down-side order with amount 750

Scenario: The trader submits a down-side order via up-side ticket-toggle
   When I open the up-side order ticket for the first-listed core contract
    And I toggle the order ticket to trade the down-side
    And I submit the order ticket with amount 950
   Then the database should have an open down-side order with amount 950

Scenario: The trader submits an order for bespoke contract by changing a core contract's Net Revenue Projection
   When I open the up-side order ticket for the first-listed core contract
    And I submit the order ticket with amount 1350 and net revenue projection of +20%
   Then the database should have an open up-side order with amount 1350 in a new instrument with net revenue projection of +20%
