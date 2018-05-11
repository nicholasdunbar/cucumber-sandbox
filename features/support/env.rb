require 'capybara'
require 'capybara/dsl'
require 'cucumber'
require 'selenium-webdriver'
require 'dot_env'
require 'nokogiri'

#load environment variables from .env file
#use > cucumber TARGET=sometarget features to load a specific .env.sometarget
$relative_path = File.expand_path("../", __FILE__);

if !ENV['TARGET'].nil? && File.file?("#{$relative_path}/.env.#{ENV['TARGET']}")
  puts "Using: .env.#{ENV['TARGET']} config"
  DotEnv.get_environment("#{$relative_path}/.env.#{ENV['TARGET']}")
elsif File.file?("#{$relative_path}/.env.dev")
    puts 'Using: .env.dev config'
    DotEnv.get_environment("#{$relative_path}/.env.dev")
else
  puts 'Using: .env config'
  DotEnv.get_environment("#{$relative_path}/.env")
end
puts "WebDriver: #{ENV['BROWSER']}"
if (ENV['BROWSER'] == 'FIREFOX-SAVED-PROFILE')
  puts "FireFox Profile: #{ENV['FFPROFILEPATH']}"
end
puts "Timeout: #{ENV['TIMEOUT']}"
#make environment available to all scripts globally 
$ENV = ENV;


  case $ENV['BROWSER']
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
    Capybara.register_driver :firefox do |app|
      profile = Selenium::WebDriver::Firefox::Profile.new
      #example of setting a profile
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
      #Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile, desired_capabilities: desired_caps)
      Capybara::Selenium::Driver.new(app, :browser => :firefox, options: options, desired_capabilities: desired_caps)
    end
    Capybara.default_driver = :firefox
  #when "FIREFOX-SAVED-PROFILE"
     #this was used with capybara (2.14.2) and selenium-webdriver (3.4.1) and has been left 
     #so that if you are using older browsers and need to set this up you still can 
     #Register driver to use a pre-saved FireFox Profile (Does not work before FF47)
     # puts "FireFox Profile: "+ENV['FFPROFILEPATH']
     # Capybara.register_driver :selenium do |app|
     #   profile = Selenium::WebDriver::Zipper.zip(ENV['FFPROFILEPATH'])
     #   caps = Selenium::WebDriver::Remote::Capabilities.firefox(
     #     {
     #       marionette: true,
     #       accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true"),
     #       firefox_options: {profile: profile}
     #     }
     #   )
     #   Capybara::Selenium::Driver.new(
     #     app,
     #     browser: :firefox,
     #     desired_capabilities: caps
     #   )
     # end
     # Capybara.current_driver = :selenium
  when "FIREFOX-SAVED-PROFILE"
    #capybara (3.0.2) selenium-webdriver (3.11.0)
    #Register driver to use a pre-saved FireFox Profile (Does not work before FF47)
    puts "FireFox Profile: "+ENV['FFPROFILEPATH']
    Capybara.register_driver :selenium do |app|
      options = Selenium::WebDriver::Firefox::Options.new
      options.profile = ENV['FFPROFILEPATH']
      #see standard properties here: https://www.w3.org/TR/webdriver/#capabilities
      caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true"),
        }
      )
      if (ENV['FIREFOXPATH'] != 'default')
        Selenium::WebDriver::Firefox.path = ENV['FIREFOXPATH']
      end
      Capybara::Selenium::Driver.new(
        app,
        browser: :firefox,
        options: options,
        desired_capabilities: caps
      )
    end
    Capybara.current_driver = :selenium
  when "SAFARI"
    #tested: Safari 10.1.1
    #result: as of Safari 10 there are many problems and not all tests will work
    #see standard properties here: https://www.w3.org/TR/webdriver/#capabilities
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
    
    #see standard properties here: https://www.w3.org/TR/webdriver/#capabilities
    desired_caps = Selenium::WebDriver::Remote::Capabilities.safari(
      {
        accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true")
      }
    )
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(
        app,
        browser: :safari,
        driver_path: '/Applications/Safari Technology Preview.app/Contents/MacOS/safaridriver',
        desired_capabilities: desired_caps
      )
    end
    Capybara.default_driver = :selenium
  else
    Capybara.register_driver :selenium do |app|
      #default to FireFox
      #see standard properties here: https://www.w3.org/TR/webdriver/#capabilities
      caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true")
        }
      )
      if (ENV['FIREFOXPATH'] != 'default')
        Selenium::WebDriver::Firefox.path = ENV['FIREFOXPATH']
      end
      Capybara::Selenium::Driver.new(
        app,
        browser: :firefox,
        desired_capabilities: caps
      )
    end
    Capybara.default_driver = :selenium
  end
Capybara.default_max_wait_time = (ENV['TIMEOUT'] || 20).to_i

#put methods and members here you want to be available in the step definitions
module CustomWorld
  def puts(text)
    STDOUT.puts text
  end
end

World(Capybara::DSL, CustomWorld)
