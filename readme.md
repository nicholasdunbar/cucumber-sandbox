# Playing with cucumber, rspec and capybara 


##How to set up the environment
run the bash script `set-up-env.sh`

##How to run the script
Edit .env.dev  
From the root of the project run  
`cucumber features/`  
To run with a custom configuration duplicate features/support/.env.dev to something like .env.custom  
`cucumber TARGET=custom features/`  

##Dependancies
**Ruby** - RSpec, Capybara and Cucumber are all programmed in Ruby

**RVM** - Makes sure this ruby install will not mess with your other installs

**Homebrew** - the `set-up-env.sh` script requires brew which only works on OSX but can be replaced easily by using another package manager 

**Cucumber** - A Ruby gem that allows mapping Ruby functions to plain text in a "features" file which will run behavior driven tests in the browser.

**Gherkin** - The .feature files that cucumber uses which allows plain english grammars to be mapped to functions in step_definitions/

**Step Definitions** - The functions programmed in ruby using the capybara functions that are called by Gherkin scripts.

**Rspec** - A Ruby defined DSL (Domain Specific Language) and a library that can be used to run behavior driven tests in the browser you can also use it to do unit tests on Ruby code if you are using Ruby in your application.

**Capybara** - A wrapper for webdrivers. Use this if you want to use one API that maps to both Chrome and Firefox. It can also be used for headless testing. Documentation found at http://www.rubydoc.info/github/jnicklas/capybara/master

**Marionette** - GeckoDriver for FireFox which is required for selenium to work. Gherkin talks to the step definitions and they then talk to capybara which then talks to selenium (if it is set up to use that driver) which then talks to GeckoDriver if you are using FireFox in capybara. It can be installed using `brew gekodriver`

###How the components interrelate
At first I didn't understand how all these dependancies worked together. Here is the gist of it.

In this set-up everything is ran in Ruby. Cucumber is the testing framework that allows us to write tests for browser automation. Gherkin and step definitions come with Cucumber. Gherkin scripts are plain english statements found in a file named like the following *.feature. Step definitions is where the code lives that Gherkin runs. In this set-up, step definitions are written in Ruby but they could be written in most any language. You can find implementations of cucumber in all sorts of languages. Each Gherkin plain english statement maps to a step definition. Function definitions for the Gherkin scripts are called step definitions and they can be found in features/step_definitions/*.rb. 

Inside the step definitions we need an API that allows us to send commands to a browser. We do this using Capybara which is a set of standard commands for browser automation, like click here or fill out this field, etc. It is a wrapper for a web driver. Web drivers are browser specific APIs that allow us to send commands to the browser. Capybara can be configured to use a number of web drivers. There are all sorts of web drivers out there, in this situation we are using the two following web drivers: GeckoDriver (which is also called Marionette) and ChromeDriver. Marionette allows us to control FireFox and ChromeDriver allows us to control Chrome. 

Ruby based Cucumber is built on top of RSpec. Rspec can also be used on it's own for browser automation if you don't need the Gherkin scripts so that the tests are human readable. If you're already using Cucumber you probably only need RSpec to do unit tests with your back-end Ruby scripts.

I hope that clears up what all these tools are and how they work together. 

##Folders 

**features** - this is where all the cucumber scripts are located  
**spec** - this is where the RSpec scripts are located

## Examples

### Step Definition Notes

Examples on commands that can be used in step definitions:  

To print to console use:  
`puts "some string"`
this calls  
`STDOUT.puts` in features/support/env.rb on the class CustomWorld

To add global custom helper functions  
add methods to the CustomWorld class in features/support/env.rb

To stall a test so you can see what is going on  
`sleep 10`

## Notes
**Poltergeist** - A headless driver which integrates Capybara with PhantomJS. It is truly headless, so doesn't require Xvfb to run on your CI server. It will also detect and report any Javascript errors that happen within the page.

**rino** - cucumber step_definitions can be written using javascript with node `npm install -g cucumber`

## Failures

### Attempts to configure the browser

Sometimes you want to configure the browser to use the settings of a certain user. This is called in fireFox the profile of the user. In FF (less than or equal to 47) you could do this easily. But now with FF moving to Marionette there is no easy way to configure Capybara to load the browser with a certain profile. I was trying to set the Firefox profile in env.rb with the following code, but something is missing:
```
require 'base64'
base64Path2Profile = Base64.encode64('/Users/dunban1/Library/Application Support/Firefox/Profiles/fc9zmymw.DefaultUser')
ffProfile = { 'profile' => base64Path2Profile }

Capybara.default_driver = :selenium
Capybara.register_driver :selenium do |app|
  #make capabilities object  
  desired_caps = Selenium::WebDriver::Remote::Capabilities.firefox(
    {
      marionette: true,
      firefox_profile: ffProfile
    }
  )
  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    desired_capabilities: desired_caps
  )
end
```

I was doing this based on a comment by @twalpol in https://github.com/teamcapybara/capybara/issues/1710

and I was guessing at the encoding required by GeckoDriver using this documentation:
https://github.com/mozilla/geckodriver

I thought eventually I would be able to set the profile to the following:
```
prefs = {
 'browser.startup.homepage_override.mstone' => 'ignore',
 'startup.homepage_welcome_url.additional' => 'about:blank',
 "browser.download.folderList" => 2,
 "browser.download.manager.showWhenStarting" => false,
 "browser.download.dir" => File.expand_path("../../../", __FILE__)+"/temp/downloads",
 "browser.helperApps.neverAsk.saveToDisk" => "application/pdf",
 "plugin.disable_full_page_plugin_for_types" => "application/pdf"
 }
 ffProfile = { 'prefs' => prefs }
```
Maybe you could take this work I've done, figure out the answer and message me. In the mean time I'm waiting for Capybara to support this with Marionette.

edited using : https://pandao.github.io/editor.md/en.html
