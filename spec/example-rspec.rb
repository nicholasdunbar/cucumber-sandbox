require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

##############################CONFIG##############################
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

#ENV variable is loaded in spec_helper.rb from .env or .env.dev
puts "WebDriver: "+ENV['BROWSER']

#Test rspec using just selenium
describe "SeleniumSpec" do

  before(:each) do
    case ENV['BROWSER']
    when "CHROME"
      @driver = Selenium::WebDriver.for :chrome, :switches => %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate]
    when "FIREFOX-PROFILE"
      #Does not work before FF48 - FF47 was the last FF version before they switched to Marrionette.
      profile = Selenium::WebDriver::Firefox::Profile.new
      #example of a hardcoded profile value
      profile['general.useragent.override'] = ENV['USERAGENT']
      desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          firefox_options: { profile: profile.as_json.values.first }
        }
      )
      @driver = Selenium::WebDriver.for :firefox, desired_capabilities: desired_caps
    when "FIREFOX-SAVED-PROFILE"
      #Does not work before FF47 
      puts ENV['FFPROFILEPATH']
      profile = Selenium::WebDriver::Zipper.zip(ENV['FFPROFILEPATH'])
      desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          firefox_options: {profile: profile},
        }
      )
      @driver = Selenium::WebDriver.for :firefox, desired_capabilities: desired_caps
    else
      #works <FF48 && >=FF48
      @driver = Selenium::WebDriver.for :firefox
    end
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  ##############################TESTS##############################
  it "check_SEIDE_version" do
    @base_url = "https://github.com/"
    @driver.get(@base_url + "/SeleniumHQ/selenium/wiki/SeIDE-Release-Notes")
    @driver.find_element(:css, "#user-content-280").click
    @driver.find_element(:xpath, "//div[@id='wiki-body']/div/ul[3]/li").text.should =~ /^[\s\S]*New[\s\S]*$/
  end
  
  # it "check_SSL_certs" do
  #   @base_url = "https://self-signed.badssl.com/"
  #   @driver.get(@base_url)
  # end
end
