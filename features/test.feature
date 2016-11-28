Feature: Test user agent
  open page from blanket/public that will show you the user agent
  
Scenario: Login
  Given the domain "https://self-signed.badssl.com/"
  And wait for "15" seconds
