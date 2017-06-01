require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'selenium-webdriver'

#ENV variable is loaded in spec_helper.rb from .env or .env.dev
puts "WebDriver: "+ENV['BROWSER']

##############################CONFIG##############################

case ENV['BROWSER']
when "CHROME"
  Capybara.default_driver = :selenium
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new app, browser: :chrome
  end
when "FIREFOX-HARDCODED-PROFILE"
  #Register driver to use a hard coded FireFox Profile 
  Capybara.register_driver :selenium do |app|
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
        accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true" || false)
      }
    )
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile, desired_capabilities: desired_caps)
  end
  Capybara.default_driver = :selenium
when "FIREFOX-SAVED-PROFILE"
  #this uses a previously created profile in FF. You can look at the paths for each profile by typing
  #in the URL bar about:profiles and then copy the path of the profile into your .env or .env.dev files
  #this allows you to set certain things in the browser like SSL exceptions that you want to be applied 
  #durring your tests. 
  #Does not work before FF47 
  puts "FireFox Profile: "+ENV['FFPROFILEPATH']
  Capybara.register_driver :selenium do |app|
    profile = Selenium::WebDriver::Zipper.zip(ENV['FFPROFILEPATH'])
    caps = Selenium::WebDriver::Remote::Capabilities.firefox(
      {
        marionette: true,
        accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true" || false),
        firefox_options: {profile: profile},
      }
    )
    
    Capybara::Selenium::Driver.new(
      app,
      browser: :firefox,
      desired_capabilities: caps
    )
  end
  Capybara.current_driver = :selenium
when "FIREFOX"
  #works <FF48 && >=FF48
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, browser: :firefox)
  end
  Capybara.default_driver = :selenium
else
  #default to Firefox
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, browser: :firefox)
  end
  Capybara.default_driver = :selenium
end
Capybara.default_max_wait_time = (ENV['TIMEOUT'] || 20).to_i

##############################TESTS##############################

#go to https://self-signed.badssl.com/ manualy and add an exception
#then if you are using FireFox go to about:profiles in address bar and get the 
#path to the FireFox Profile and set it in /features/step_definitions/.env.dev 
#run test to see if the exception you
describe 'EXPIRED SSL CERT TEST', :js => true, :type => :feature do
  it "test ssl cert" do
    #test if ssl cert exception is working 
    visit 'https://self-signed.badssl.com/'
    page.save_screenshot('screenshots/rspec+capybara+selenium.png')
    sleep 5
  end
end
