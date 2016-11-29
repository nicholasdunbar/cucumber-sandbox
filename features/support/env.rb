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
puts "Browser: #{ENV['BROWSER']}"
puts "Timeout: #{ENV['TIMEOUT']}"
#make environment available to all scripts globally 
$ENV = ENV;


  case $ENV['BROWSER']
  when "CHROME"
    Capybara.default_driver = :selenium
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new app, browser: :chrome
    end
  when "FIREFOX-PROFILE"
    #Register driver to use a hard coded FireFox Profile 
    Capybara.register_driver :firefox do |app|
      profile = Selenium::WebDriver::Firefox::Profile.new
      #example of setting a profile
      profile['general.useragent.override'] = ENV['USERAGENT']
      desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          marionette: true,
          firefox_options: { profile: profile.as_json.values.first }
        }
      )
      Capybara::Selenium::Driver.new(app, :browser => :firefox, desired_capabilities: desired_caps)
    end
    Capybara.default_driver = :firefox
  when "FIREFOX-SAVED-PROFILE"
    #Register driver to use a presaved FireFox Profile (Does not work before FF47)
    puts "FireFox Profile: "+ENV['FFPROFILEPATH']
    Capybara.register_driver :geckodriver do |app|
      profile = Selenium::WebDriver::Zipper.zip(ENV['FFPROFILEPATH'])
      caps = Selenium::WebDriver::Remote::Capabilities.firefox(
        {
          firefox_options: {profile: profile},
        }
      )
      
      Capybara::Selenium::Driver.new(
        app,
        browser: :firefox,
        desired_capabilities: caps
      )
    end
    Capybara.current_driver = :geckodriver
  else
    Capybara.register_driver :firefox do |app|
      Capybara::Selenium::Driver.new app, browser: :firefox
    end
    Capybara.default_driver = :firefox
  end
Capybara.default_max_wait_time = (ENV['TIMEOUT'] || 20).to_i

#put methods and members here you want to be available in the step definitions
module CustomWorld
  def puts(text)
    STDOUT.puts text
  end
end

World(Capybara::DSL, CustomWorld)
