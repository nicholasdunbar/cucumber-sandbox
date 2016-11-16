Feature: This is a hello world 
  In order to start learning RSpec and Cucumber
  This is a hellow world example
  I want a greeter to say Hello
  
Scenario: greeter says hello
  Given a greeter
  When I send it the greet message
  Then I should see "Hello Cucumber!"
