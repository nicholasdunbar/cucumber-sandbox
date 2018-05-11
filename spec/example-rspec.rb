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
if (ENV['FIREFOXPATH'] != 'default')
  puts "Using executable: "+ENV['FIREFOXPATH']
end
if (ENV['BROWSER'] == 'FIREFOX-SAVED-PROFILE')
  puts "FireFox Profile: "+ENV['FFPROFILEPATH']
end

#Test rspec using just selenium
describe "SeleniumSpec" do

  before(:each) do
    case ENV['BROWSER']
    when "CHROME"
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--disable-popup-blocking')
      options.add_argument('--disable-translate')
      if (ENV['ACCEPTALLCERTS'] == "true")
        #this was used with capybara (2.14.2) and selenium-webdriver (3.4.1)
        #addswitch = %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate]
        options.add_argument('--ignore-certificate-errors')
      else 
        #this was used with capybara (2.14.2) and selenium-webdriver (3.4.1)
        #addswitch = %w[--disable-popup-blocking --disable-translate]
      end
      #this was used with capybara (2.14.2) and selenium-webdriver (3.4.1)
      #@driver = Selenium::WebDriver.for :chrome, :switches => addswitch
      #capybara (3.0.2) selenium-webdriver (3.11.0)
      @driver = Selenium::WebDriver.for :chrome, options: options
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
      options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
      desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true")
        }
      )
      if (ENV['FIREFOXPATH'] != 'default')
        Selenium::WebDriver::Firefox.path = ENV['FIREFOXPATH']
      end
      #this was used with capybara (2.14.2) and selenium-webdriver (3.4.1)
      #@driver = Selenium::WebDriver.for :firefox, :profile => profile, desired_capabilities: desired_caps
      @driver = Selenium::WebDriver.for :firefox, options: options, desired_capabilities: desired_caps

    # when "FIREFOX-SAVED-PROFILE"
      #this was used with capybara (2.14.2) and selenium-webdriver (3.4.1) and has been left 
      #so that if you are using older browsers and need to set this up you still can 
      #this uses a previously created profile in FF. You can look at the paths for each profile by typing
      #in the URL bar about:profiles and then copy the path of the profile into your .env or .env.dev files
      #this allows you to set certain things in the browser like SSL exceptions that you want to be applied 
      #durring your tests. 
      #Does not work before FF47 
      # puts "FireFox Profile: "+ENV['FFPROFILEPATH']
      # profile = Selenium::WebDriver::Zipper.zip(ENV['FFPROFILEPATH'])
      # desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
      #   {
      #     marionette: true,
      #     accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true"),
      #     firefox_options: {profile: profile},
      #   }
      # )
      # @driver = Selenium::WebDriver.for :firefox, desired_capabilities: desired_caps
    when "FIREFOX-SAVED-PROFILE"
      #capybara (3.0.2) selenium-webdriver (3.11.0)
      #this uses a previously created profile in FF. You can look at the paths for each profile by typing
      #in the URL bar about:profiles and then copy the path of the profile into your .env or .env.dev files
      #this allows you to set certain things in the browser like SSL exceptions that you want to be applied 
      #durring your tests. 
      #Does not work before FF47 

      options = Selenium::WebDriver::Firefox::Options.new
      options.profile = ENV['FFPROFILEPATH']
      desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true"),
        }
      )
      if (ENV['FIREFOXPATH'] != 'default')
        Selenium::WebDriver::Firefox.path = ENV['FIREFOXPATH']
      end
      @driver = Selenium::WebDriver.for :firefox, options: options, desired_capabilities: desired_caps
    when "FIREFOX"
      #works >=FF48
      desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true")
        }
      )
      if (ENV['FIREFOXPATH'] != 'default')
        Selenium::WebDriver::Firefox.path = ENV['FIREFOXPATH']
      end
      @driver = Selenium::WebDriver.for :firefox, desired_capabilities: desired_caps
    when "SAFARI"
      #This is a standard property but doesn't seem to be working in Safari yet:
      # desired_caps = Selenium::WebDriver::Remote::Capabilities.safari(
      #   {
      #     accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true")
      #   }
      # )
      @driver = Selenium::WebDriver.for :safari #,desired_capabilities: desired_caps
    when "SAFARI-TECHNOLOGY-PREVIEW"
      #This is a standard property but doesn't seem to be working in Safari yet:
      # desired_caps = Selenium::WebDriver::Remote::Capabilities.safari(
      #   {
      #     accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true")
      #   }
      # )
      @driver = Selenium::WebDriver.for :safari, driver_path: '/Applications/Safari Technology Preview.app/Contents/MacOS/safaridriver' #,desired_capabilities: desired_caps
    else
      #default to Firefox
      #works <FF48 && >=FF48
      @driver = Selenium::WebDriver.for :firefox
    end
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = (ENV['TIMEOUT'] || 20).to_i
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
    @driver.save_screenshot('screenshots/rsec+selenium+check+seide.png')
    sleep 5
  end
  
  it "check_SSL_certs" do
    #test that self-signed exception is working
    @base_url = "https://self-signed.badssl.com/"
    @driver.get(@base_url)
    @driver.save_screenshot('screenshots/rsec+selenium+baddssl.png')
    sleep 5
  end
end
