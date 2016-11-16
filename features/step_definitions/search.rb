Given(/^I am on google$/) do
  Capybara.app_host = "http://www.google.com"
  visit '/'
end
 
Given(/^I search for "([^"]*)"$/) do |term|
  #fill the cucumber search box
  #example: 
  #<input type="text" id="css-id"/> 
  #fill_in 'css-id', :with => 'some text'
  fill_in 'lst-ib', :with => term
  find('#lst-ib').native.send_keys(:return)
end


 
Then(/^I should be able to see the header "([^"]*)"$/) do |term|
  #test the h1 title is equal to Cucumber
  find('h1').text == term
  sleep 3
end 
