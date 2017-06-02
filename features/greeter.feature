Feature: This is a hello world 
  This is a hello world example 
  It shows using RSpec only as a unit test (not controlling the browser)
  I want a greeter to say Hello
  
Scenario: greeter says hello
  Given a greeter
  When I send it the greet message
  Then I should see "Hello Cucumber!"
