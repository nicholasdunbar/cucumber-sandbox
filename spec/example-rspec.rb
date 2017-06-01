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
    when "FIREFOX-HARDCODED-PROFILE"
      profile = Selenium::WebDriver::Firefox::Profile.new
      #this allows you to encode values into a temporary profile that exists only durring testing. 
      #you can look up each of the values at the following URL:
      #documentation: http://www.rubydoc.info/gems/selenium-webdriver/0.0.28/Selenium/WebDriver/Firefox/Profile
      #Does not work before FF48 (FF47 was the last FF version before Mozilla switched to Marrionette)
      #example of a hardcoded profile value
      profile['general.useragent.override'] = ENV['USERAGENT']
      #to make sure downloaded files go to the downloads directory
      profile['browser.download.folderList'] = 2
      profile['browser.download.manager.showWhenStarting'] = false
      profile['browser.download.dir'] = File.expand_path("../../../", __FILE__)+"/downloads"
      profile['browser.helperApps.neverAsk.saveToDisk'] = "application/pdf"
      profile['plugin.disable_full_page_plugin_for_types'] = "application/pdf"
      desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          accept_insecure_certs: true
        }
      )
      @driver = Selenium::WebDriver.for :firefox, :profile => profile, desired_capabilities: desired_caps

    when "FIREFOX-SAVED-PROFILE"
      #this uses a previously created profile in FF. You can look at the paths for each profile by typing
      #in the URL bar about:profiles and then copy the path of the profile into your .env or .env.dev files
      #this allows you to set certain things in the browser like SSL exceptions that you want to be applied 
      #durring your tests. 
      #Does not work before FF47 
      puts "FireFox Profile: "+ENV['FFPROFILEPATH']
      profile = Selenium::WebDriver::Zipper.zip(ENV['FFPROFILEPATH'])
      desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          firefox_options: {profile: profile},
        }
      )
      @driver = Selenium::WebDriver.for :firefox, desired_capabilities: desired_caps
    when "FIREFOX"
      #works <FF48 && >=FF48
      @driver = Selenium::WebDriver.for :firefox
    else
      #default to Firefox
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
  # it "check_SEIDE_version" do
  #   @base_url = "https://github.com/"
  #   @driver.get(@base_url + "/SeleniumHQ/selenium/wiki/SeIDE-Release-Notes")
  #   @driver.find_element(:css, "#user-content-280").click
  #   @driver.find_element(:xpath, "//div[@id='wiki-body']/div/ul[3]/li").text.should =~ /^[\s\S]*New[\s\S]*$/
  # end
  
  it "check_SSL_certs" do
    # @base_url = "https://self-signed.badssl.com/"
    @base_url = "http://localhost:5000/index.html"
    @driver.get(@base_url)
    @driver.save_screenshot('screenshots/rsec+selenium.png')
    sleep 5
  end
end
