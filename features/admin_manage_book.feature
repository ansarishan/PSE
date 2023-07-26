@javascript
Feature: An Admin can manage drug periods

Background:
  Given I log in as an admin

#open/close buttons suppressed for now
@wip
Scenario Outline: Admin opens/closes a book
  Given the test creates a drug period that is <from_state>
    And I visit the admin contract list
   Then I should see that the first drug period is <from_state>

   When I <action> the first drug period
   Then I should see that the first drug period is <to_state>
    And the DB should have one drug period that is <to_state>

  Examples:
    | from_state | action | to_state |
    | closed     | open   | open     |
    | open       | close  | closed   |


Scenario: Admin expires an orderless book
  Given the test creates a drug period that is open
    And I visit the admin contract list
   When I expire the first drug period, specifying actual net revenue "545"
   Then the DB should have recorded that period as being expired with net revenue "545"

Scenario: Admin expires a book that has orders
  Given the test creates a drug period that is open
    And the test gives this drug period 1 maturing trade
    And the test gives this drug period 1 in-negotiation trade
    And the test gives this drug period 1 open order
    And I visit the admin contract list

   When I expire the first drug period, specifying actual net revenue "747"
   Then the DB should have recorded that period as being expired with net revenue "747"
    And this drug period should have 1 settled trade with settlement values recorded
    And the system should have sent 2 settlement emails
    And this drug period should have 1 expired trade
    # 2 orders are from the expired trade, and the other is unmatched
    And this drug period should have 3 expired orders

