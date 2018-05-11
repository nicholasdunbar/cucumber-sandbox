require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'selenium-webdriver'

#ENV variable is loaded in spec_helper.rb from .env or .env.dev
puts "WebDriver: "+ENV['BROWSER']
if (ENV['FIREFOXPATH'] != 'default')
  puts "Using executable: "+ENV['FIREFOXPATH']
end
if (ENV['BROWSER'] == 'FIREFOX-SAVED-PROFILE')
  puts "FireFox Profile: "+ENV['FFPROFILEPATH']
end

##############################CONFIG##############################

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
  Capybara.register_driver :selenium do |app|
    #this was used with capybara (2.14.2) and selenium-webdriver (3.4.1)
    #Capybara::Selenium::Driver.new(app, browser: :chrome, :switches => addswitch)
    #capybara (3.0.2) selenium-webdriver (3.11.0)
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
  Capybara.default_driver = :selenium
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
    #to make sure downloaded files like PDFs go to the downloads directory
    profile['browser.download.folderList'] = 2
    profile['browser.download.manager.showWhenStarting'] = false
    profile['browser.download.dir'] = File.expand_path("../../../", __FILE__)+"/downloads"
    profile['browser.helperApps.neverAsk.saveToDisk'] = "application/pdf"
    profile['plugin.disable_full_page_plugin_for_types'] = "application/pdf"
    options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
    #https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings#ssl-certificates
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
    #Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile, desired_capabilities: desired_caps)
    Capybara::Selenium::Driver.new(app, :browser => :firefox, options: options, desired_capabilities: desired_caps)
  end
  Capybara.default_driver = :selenium
## legacy capybara (2.14.2)
# when "FIREFOX-SAVED-PROFILE"
  ## this was used with capybara (2.14.2) and selenium-webdriver (3.4.1) and has been left 
  ## so that if you are using older browsers and need to set this up you still can 
  ## this uses a previously created profile in FF. You can look at the paths for each profile by typing
  ## in the URL bar about:profiles and then copy the path of the profile into your .env or .env.dev files
  ## this allows you to set certain things in the browser like SSL exceptions that you want to be applied 
  ## durring your tests. 
  ## Does not work before FF47 
  # puts "FireFox Profile: "+ENV['FFPROFILEPATH']
  # Capybara.register_driver :selenium do |app|
  #   profile = Selenium::WebDriver::Zipper.zip(ENV['FFPROFILEPATH'])
  #   desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
  #     {
  #       marionette: true,
  #       accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true"),
  #       firefox_options: {profile: profile},
  #     }
  #   )
  # 
  #   Capybara::Selenium::Driver.new(
  #     app,
  #     browser: :firefox,
  #     desired_capabilities: desired_caps
  #   )
  # end
  # Capybara.current_driver = :selenium 
when "FIREFOX-SAVED-PROFILE"
  #capybara (3.0.2) selenium-webdriver (3.11.0)
  #this uses a previously created profile in FF. You can look at the profile name by typing
  #in the URL bar about:profiles and then copy the name of the profile into your .env or .env.dev files
  #this allows you to set certain things in the browser like SSL exceptions that you want to be applied 
  #durring your tests. It does take longer to load 
  #Does not work before FF47 
  
  Capybara.register_driver :selenium do |app|
    options = Selenium::WebDriver::Firefox::Options.new
    options.profile = ENV['FFPROFILEPATH']
    #https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings#ssl-certificates
    desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
      {
        marionette: true,
        accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true"),
      }
    )
    
    Capybara::Selenium::Driver.new(
      app,
      browser: :firefox,
      options: options,
      desired_capabilities: desired_caps
    )
  end
   
  if (ENV['FIREFOXPATH'] != 'default')
    Selenium::WebDriver::Firefox.path = ENV['FIREFOXPATH']
  end 
  Capybara.current_driver = :selenium
when "FIREFOX"
  #works >=FF48
  #https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings#ssl-certificates
  desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
    {
      marionette: true,
      accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true")
    }
  )
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(
      app, 
      browser: :firefox,
      desired_capabilities: desired_caps
    )
  end
  if (ENV['FIREFOXPATH'] != 'default')
    Selenium::WebDriver::Firefox.path = ENV['FIREFOXPATH']
  end
  Capybara.default_driver = :selenium
when "SAFARI"
  #tested: Safari 10.1.1
  #result: as of Safari 10 there are many problems and not all tests will work
  #This is a standard property but doesn't seem to be working in Safari yet: 
  # desired_caps = Selenium::WebDriver::Remote::Capabilities.safari(
  #   {
  #     accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true")
  #   }
  # )
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(
      app,
      browser: :safari #,
      #desired_capabilities: desired_caps
    )
  end
  Capybara.default_driver = :selenium
when "SAFARI-TECHNOLOGY-PREVIEW"
  #This is what we use to test the Safari release channel. 
  #You will have to install Safari Technology Preview from Apple.
  #This is a standard property but doesn't seem to be working in Safari yet:
  # desired_caps = Selenium::WebDriver::Remote::Capabilities.safari(
  #   {
  #     accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true")
  #   }
  # )
  
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(
      app,
      browser: :safari,
      driver_path: '/Applications/Safari Technology Preview.app/Contents/MacOS/safaridriver' #,
      #desired_capabilities: desired_caps
    )
  end
  Capybara.default_driver = :selenium
else
  #default to Firefox
  #works <FF48 && >=FF48
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
describe 'EXAMPLE TESTS', :js => true, :type => :feature do
  it "ssl cert" do
    #test if ssl cert exception is working 
    visit 'https://self-signed.badssl.com/'
    #puts page.driver.browser.manage.window.inspect
    #worked < chromedriver 2.33 with Chrome 62.
    #page.driver.browser.manage.window.resize_to 1024, 768
    # > chromedriver 2.33 with Chrome 62.
    page.current_window.resize_to 1024, 768
    page.save_screenshot('screenshots/rspec+capybara+selenium.png')
    sleep 1
  end
  it "close page with alert open" do
    visit 'http://www.javascripter.net/faq/confirm.htm'
    page.current_window.resize_to 1024, 768
    page.accept_alert do
      click_button "Try it now"
    end
    sleep 1
  end
end
