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
puts "Timeout: #{ENV['TIMEOUT']}"
#make environment available to all scripts globally 
$ENV = ENV;


  case $ENV['BROWSER']
  when "CHROME"
    if (ENV['ACCEPTALLCERTS'] == "true")
      addswitch = %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate]
    else 
      addswitch = %w[--disable-popup-blocking --disable-translate]
    end
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome, :switches => addswitch)
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
      desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true")
        }
      )
      Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile, desired_capabilities: desired_caps)
    end
    Capybara.default_driver = :firefox
  when "FIREFOX-SAVED-PROFILE"
    #Register driver to use a pre-saved FireFox Profile (Does not work before FF47)
    puts "FireFox Profile: "+ENV['FFPROFILEPATH']
    Capybara.register_driver :selenium do |app|
      profile = Selenium::WebDriver::Zipper.zip(ENV['FFPROFILEPATH'])
      caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true"),
          firefox_options: {profile: profile}
        }
      )
      Capybara::Selenium::Driver.new(
        app,
        browser: :firefox,
        desired_capabilities: caps
      )
    end
    Capybara.current_driver = :selenium
  else
    Capybara.register_driver :selenium do |app|
      caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          accept_insecure_certs: (ENV['ACCEPTALLCERTS'] == "true")
        }
      )
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
