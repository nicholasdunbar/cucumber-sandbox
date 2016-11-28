require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

#Test rspec using just selenium
describe "SeleniumSpec" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "https://github.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "check_version" do
    @driver.get(@base_url + "/SeleniumHQ/selenium/wiki/SeIDE-Release-Notes")
    @driver.find_element(:css, "#user-content-280").click
    @driver.find_element(:xpath, "//div[@id='wiki-body']/div/ul[3]/li").text.should =~ /^[\s\S]*New[\s\S]*$/
  end
end
