Feature: Login to bank and download statement
  This is used as an example 
  this automates getting bank statements

Scenario: Login
  Given the domain "https://www.wellsfargo.com"
  When username is set
  When password is set
  When the go button is clicked
  And the "Statements & Documents" link is clicked within "#navfooter"
  Given the page contains "Statements and Documents"
  #And the "Statements and Disclosures" link is clicked
  And open the statement list
  Then the statement list is open
  And download missing docs
  And wait for "5" seconds
