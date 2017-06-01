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
    #example of a hardcoded profile value
    profile['general.useragent.override'] = ENV['USERAGENT']
    desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
      {
        marionette: true,
        accept_insecure_certs: true,
        firefox_options: { profile: profile.as_json.values.first }
      }
    )
    Capybara::Selenium::Driver.new(app, :browser => :firefox, desired_capabilities: desired_caps)
  end
  Capybara.default_driver = :selenium
when "FIREFOX-SAVED-PROFILE"
  #Register driver to use a presaved FireFox Profile (Does not work before FF47)
  puts "FireFox Profile: "+ENV['FFPROFILEPATH']
  Capybara.register_driver :selenium do |app|
    profile = Selenium::WebDriver::Zipper.zip(ENV['FFPROFILEPATH'])
    caps = Selenium::WebDriver::Remote::Capabilities.firefox(
      {
        marionette: true,
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
    visit 'https://self-signed.badssl.com/'
    # page.save_screenshot('screenshot.png')
    sleep 30
  end
end
