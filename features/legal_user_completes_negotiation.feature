@javascript
Feature: A Legal user can complete negotiation of a trade

Background:
  Given this test creates Fosamax instruments
  And I log in as a lawyer
  And I have a negotiating trade with amount 22250

Scenario: Order is placed into Legal Approved status
    When I visit '/dashboard'
     And I click the View link for the first negotiating trade
     And I click Confirm Contract
     And I accept the confirmation dialog
    Then I should see "Contract confirmed."
     And the database should have my legal_approved up order for 22250 and its negotiating trade
    When the counterparty to my up order for 22250 confirms the contract
    Then the database should have my legal_approved up order for 22250 and its maturing trade
    And  the database should have my counterparty's legal_approved down order for 22250 and its maturing trade

