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

Capybara.default_driver = :selenium
Capybara.register_driver :selenium do |app|
  case $ENV['BROWSER']
  when "CHROME"
    Capybara::Selenium::Driver.new app, browser: :chrome
  else
    Capybara::Selenium::Driver.new app, browser: :firefox
  end
end
Capybara.default_max_wait_time = (ENV['TIMEOUT'] || 20).to_i

#put methods and members here you want to be available in the step definitions
module CustomWorld
  def puts(text)
    STDOUT.puts text
  end
end

World(Capybara::DSL, CustomWorld)
