Given /^url "([^"]*)"$/ do |url|
  Capybara.app_host = url
  visit '/'
end

When /^username is set$/ do 
  fill_in 'userid', :with => ENV['BANKUSER']
end

When /^password is set$/ do
  fill_in 'password', :with => ENV['BANKPASS']
end

Then /^there is an h2 "([^"]*)"$/ do |arg1|
  find(:xpath, '//*[@id="shell"]/div[3]/div[1]/div[1]/div[1]/div/div/h2').text == arg1
  sleep 10
end
