@javascript

# Units:
# * Projection is in Millions
# * Levs are integers, representing a multiplier
# * Caps are integers, representing a percent

Feature: Trade ticket calculator

Background:
  Given this test creates a Fosamax instrument with projection=10
    And I log in as a trader
    And I visit the first Fosamax book
    And I open the up-side order ticket for the first-listed core contract
    And I open the calculator

Scenario Outline: Up-side calculations
   When I enter calculator params revenue=<Revenue> amount=<Amount> upLev=<UpLev> upCap=<UpCap> downCap=<DownCap> downLev=<DownLev>
   Then I should see calculator results maxReturn=<MaxReturn> maxLoss=<MaxLoss> totalRoL=<TotalRoL>

  Examples:
    | Revenue | Amount | UpLev | UpCap | DownCap | DownLev | MaxReturn   | MaxLoss      | TotalRoL     |
    | 11      | 1000   | 2     | 40    | 40      | 2       | $400,000.00 | -$400,000.00 |  $200,000.00 |
    | 13      | 1000   | 2     | 40    | 40      | 2       | $400,000.00 | -$400,000.00 |  $400,000.00 |
    |  9      | 1000   | 2     | 40    | 40      | 2       | $400,000.00 | -$400,000.00 | -$200,000.00 |
    |  7      | 1000   | 2     | 40    | 40      | 2       | $400,000.00 | -$400,000.00 | -$400,000.00 |
    | 11      | 1000   | 2     | 35    | 45      | 2       | $350,000.00 | -$450,000.00 |  $200,000.00 |
  
Scenario Outline: Down-side calculations
   When I enter calculator params revenue=<Revenue> amount=<Amount> upLev=<UpLev> upCap=<UpCap> downCap=<DownCap> downLev=<DownLev>
    And I toggle the calculator side to down
   Then I should see calculator results maxReturn=<MaxReturn> maxLoss=<MaxLoss> totalRoL=<TotalRoL>

  Examples:
    | Revenue | Amount | UpLev | UpCap | DownCap | DownLev | MaxReturn   | MaxLoss      | TotalRoL     |
    | 11      | 1000   | 2     | 40    | 40      | 2       | $400,000.00 | -$400,000.00 | -$200,000.00 |
    | 13      | 1000   | 2     | 40    | 40      | 2       | $400,000.00 | -$400,000.00 | -$400,000.00 |
    |  9      | 1000   | 2     | 40    | 40      | 2       | $400,000.00 | -$400,000.00 |  $200,000.00 |
    |  7      | 1000   | 2     | 40    | 40      | 2       | $400,000.00 | -$400,000.00 |  $400,000.00 |
    | 11      | 1000   | 2     | 35    | 45      | 2       | $450,000.00 | -$350,000.00 | -$200,000.00 |

