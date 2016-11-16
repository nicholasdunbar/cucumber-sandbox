# Playing with cucumber, rspec and capybara 


##How to set up the environment
run the bash script `set-up-env.sh`

##How to run the script
`cucumber features`

## Dependancies
**Ruby** - RSpec, Capybara and Cucumber are all programmed in Ruby

**RVM** - Makes sure this ruby install will not mess with your other installs

**Homebrew** - the `set-up-env.sh` script requires brew which only works on OSX but can be replaced easily by using another package manager 

**Cucumber** - A Ruby gem that allows mapping Ruby functions to plain text in a "features" file which will run behavior driven tests in the browser.

**Gherkin** - The .feature files that cucumber uses which allows plain english grammars to be mapped to functions in step_definitions/

**Step Definitions** - The functions programmed in ruby using the capybara functions that are called by Gherkin scripts.

**Rspec** - A Ruby defined DSL (Domain Specific Language) and a library that can be used to run behavior driven tests in the browser you can also use it to do unit tests on Ruby code if you are using Ruby in your application.

**Capybara** - A wrapper for webdrivers. Use this if you want to use one API that maps to both Chrome and Firefox. It can also be used for headless testing. Documentation found at http://www.rubydoc.info/github/jnicklas/capybara/master

**Marionette** - GeckoDriver for FireFox which is required for selenium to work. Gherkin talks to the step definitions and they then talk to capybara which then talks to selenium (if it is set up to use that driver) which then talks to GeckoDriver if you are using FireFox in capybara. It can be installed using `brew gekodriver`



## Examples

### Step Definition Notes

Examples on commands that can be used in step definitions
to print to console use:  
`STDOUT.puts "test global vars"`
to stall a test so you can see what is going on
`sleep 10`

## Notes
**Poltergeist** - A headless driver which integrates Capybara with PhantomJS. It is truly headless, so doesn't require Xvfb to run on your CI server. It will also detect and report any Javascript errors that happen within the page.

**rino** - cucumber step_definitions can be written using javascript with node `npm install -g cucumber`

## Failures

### Attempts to configure the browser

I was trying to set the firefox profile in env.rb with the following code, but something is missing:
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

edited using : https://pandao.github.io/editor.md/en.html
