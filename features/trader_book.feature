@javascript

Feature: Trader's view into book

Background:
  Given this test creates Fosamax instruments

Scenario: The trader views a book
  Given I log in as a trader
  And I visit the first Fosamax book
  Then I should see the first Fosamax book

Scenario: The book visually demarcates contracts with active up and down orders
  Given my organization has an open up order for 1200 in the first Fosamax instrument
    And my organization has an open down order for 1350 in the second Fosamax instrument

   When I log in as a trader
    And I visit the first Fosamax book
   Then I should see that the first Fosamax instrument reflects an open up order for 1200
   Then I should see that the second Fosamax instrument reflects an open down order for 1350
