Feature: Login to bank and download statement
  This automates getting my bank statements

Scenario: Login
  Given url "https://www.wellsfargo.com"
  When username is set
  When password is set
  Then there is an h2 "Buying a house?"
