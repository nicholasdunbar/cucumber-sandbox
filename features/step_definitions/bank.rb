#Given the domain "____"
Given /^the domain "([^"]*)"$/ do |url|
  Capybara.app_host = url
  visit '/'
end
#given the domain "____" and page "____"
Given /^the domain "([^"]*)" and page "([^"]*)"$/ do |url, pageName|
  Capybara.app_host = url
  visit '/'+pageName
end
#then the page contains "____"
Then /^the page contains "([^"]*)"$/ do |arg1|
  expect(page).to have_content(arg1)
end
#and username is set
And /^username is set$/ do 
  fill_in 'userid', :with => ENV['BANKUSER']
end
#and password is set
And /^password is set$/ do
  fill_in 'password', :with => ENV['BANKPASS']
end
#the go button is clicked
When /^the go button is clicked$/ do
  click_button "btnSignon"
end
#the "____" link is clicked within "____"
And /^the "([^"]*)" link is clicked within "([^"]*)"$/ do |arg1,arg2|
  within arg2 do
    click_link arg1
  end
end
#the "____" link is clicked
And /^the "([^"]*)" link is clicked$/ do |arg1|
  path="//a/*[.='#{arg1}'][1]"
  find(:xpath, path).click
end
#open the statement list
And /^open the statement list$/ do 
  path='//*[@id="stmtdisc"]/span[1]'
  find(:xpath, path).click
end
#the statement list is open
Then /^the statement list is open$/ do
  path="//h3[.='Statements']"
  find(:xpath, path).text == "Statements"
end
#download missing docs
And /^download missing docs$/ do
  results = find(:xpath, '//*[@id="stmtdisc-tile-container"]/div')
  contents = results.native.attribute('outerHTML')
  nodes = Nokogiri::HTML(contents);
  date = ""
  inner_html = ""
  nodes.css('a').each do |link| 
    #example: Statement 12/31/2015 (23K, PDF)
    matches = /Statement\s([0-9\/]{8,10}?)\s/.match link.content;
    date = matches[1] 
    inner_html = link.content
    break
  end
  #download content
  puts "downloading : "+date
  path="//a[.='#{inner_html}']"
  find(:xpath, path).click
end
#wait for "____" seconds
Then /^wait for "(\d+)" seconds$/ do |arg1|
  seconds = (arg1 || 0).to_i
  sleep seconds
end
#save the page
Then /^save the page$/ do
  save_and_open_page
end
