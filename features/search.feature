Feature: Example of a search for Turner & Hooch using Google
 
Scenario: Search for turner and hooch
  Given I am on google
  And I search for "turner & hooch"
  When the "Turner & Hooch - Wikipedia" link is clicked within "#ires"
  Then I should be able to see the header "Turner & Hooch"
