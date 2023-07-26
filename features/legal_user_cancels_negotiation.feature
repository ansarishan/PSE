@javascript
Feature: A Legal user can cancel negotiation of a trade

Background:
  Given this test creates Fosamax instruments
  And I log in as a lawyer

Scenario: An unconfirmed Trade and its Orders are canceled
  Given I have a unconfirmed trade with amount 33350
    When I visit '/dashboard'
     And I click the View link for the first unconfirmed trade
     And I click Cancel Contract
     And I accept the confirmation dialog
    Then I should see "Contract canceled."
     And the database should have my canceled up order for 33350 and its canceled trade
    And  the database should have my counterparty's canceled down order for 33350 and its canceled trade

Scenario: A negotiating Trade and its Orders are canceled
  Given I have a negotiating trade with amount 44450
    When I visit '/dashboard'
     And I click the View link for the first negotiating trade
     And I click Cancel Contract
     And I accept the confirmation dialog
    Then I should see "Contract canceled."
     And the database should have my canceled up order for 44450 and its canceled trade
    And  the database should have my counterparty's canceled down order for 44450 and its canceled trade

