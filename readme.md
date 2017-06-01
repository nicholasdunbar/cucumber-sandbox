# Sandbox for Cucumber, RSpec, Capybara and Marionette
This is a full set-up of the above technologies since the FF48 switch to Marrionette. You can clone this repository for your own learning and start playing with these libraries. Since Marrionette is still being developed some features may not work.

Tested on : Mac OSX 10.12.5 Sierra  

## How to set up the environment
run the bash script `set-up-env.sh`

## Examples of how to use different technology combinations
cucumber+capybara - multiple examples in features folder  
rspec+capybara - spec/example-rspec-capybara.rb  
rspec+selenium - spec/example-rspec.rb  

## How to run a Cucumber script
Edit features/support/.env.dev  (env.dev is generated by the set-up-env.sh script)  
From the root of the project run  
`cucumber features/`  
To run with a custom configuration duplicate features/support/.env.dev to something like .env.custom  
`cucumber TARGET=custom features/`  

## How to run a RSpec script
Edit spec/.env.dev (env.dev is generated by the set-up-env.sh script)  
From the root of the project run  
`rspec spec/example-rspec-capybara.rb`  
or for rspec+selenium  
`rspec spec/example-rspec.rb`  

## Dependancies
**Chrome** - This sandbox supports the Chrome browser

**FireFox** - This sandbox supports the FireFox browser only with the following configurations: RSpec+Selenium and Cucumber+Capybara. It does not support FireFox with RSpec+Capybara (this is due to the changes since FF48 when Marrionette and GeckoDriver was introduced this project is here to try and figure out all the new configurations needed for FireFox).

**WebKit** - not yet supported in this project

**Ruby** - RSpec, Capybara and Cucumber are all programmed in Ruby in this example, but you can get them in different languages.

**RVM** - Makes sure this Ruby install will not mess with your other installs

**Homebrew** - the `set-up-env.sh` script requires brew which only works on OSX but can be replaced easily by using another package manager 

**Cucumber** - A Ruby gem that allows mapping Ruby functions to plain text in a "features" file which will run behavior driven tests in the browser.

**Gherkin** - The .feature files that Cucumber uses which allows plain english grammars to be mapped to functions in step_definitions/

**Step Definitions** - The functions programmed in Ruby using the capybara functions that are called by Gherkin scripts.

**Rspec** - A Ruby defined DSL (Domain Specific Language) and a library that can be used to run behavior driven tests in the browser you can also use it to do unit tests on Ruby code if you are using Ruby in your application. The following would be an example of RSpec with Selenium being used as the API to the webdriver written in Ruby:  
```
it "check_SEIDE_version" do
   @base_url = "https://github.com/"
   @driver.get(@base_url + "/SeleniumHQ/selenium/wiki/SeIDE-Release-Notes")
   @driver.find_element(:css, "#user-content-280").click
   @driver.find_element(:xpath, "//div[@id='wiki-body']/div/ul[3]/li").text.should =~ /^[\s\S]*New[\s\S]*$/
 end
```
The `it` and `describe` commands are examples of RSpec you can put either Selenium or Capybara inside of those statements to automate the browser.

**Capybara** - A wrapper for web drivers. Use this if you want to use one API that maps to any web driver of your choice. In this case we are using selenium which provides and API to both Chrome and Firefox, but you could replace it with other web drivers. It can also be used for headless testing. Documentation found at http://www.rubydoc.info/github/jnicklas/capybara/master  

**Selenium** - A web driver that works for both Chrome and FireFox. It provides one API for both browsers which in this case is in Ruby but could be in any number of languages. In this set-up we are wrapping selenium inside of Capybara (with the exception of `spec/example-rspec.rb` which access the Selenium webdriver directly) so we don't need to make direct calls on the selenium API. Selenium has two different paths to automate FireFox and Chrome. It talks to FireFox through Marionette (which depends on GeckoDriver) and it talks to Chrome through ChromeDriver. So why do we use Capybara? Because it allows for more freedom in what drivers we want to use. This way we aren't locked in to selenium because Capybara has one standard API that is webdriver agnostic. Also some would argue that the Capybara library, as browser automation APIs go, is easier to use than the Selenium one.  

**Marionette** -  A set of tools for automating and testing Gecko-based browsers like Firefox. GeckoDriver and Marionette Server are some of those such tools. Marrionette implements an automation protocol using W3C WebDriver compatibility. Its goal is to replicate what Selenium does but again, only for Gecko-based browsers. We still need Selenium, if we want to be able to talk to multiple browsers. Selenium 3.0 or later, enables support for Marionette by default.  

**GeckoDriver**  - A web driver. GeckoDriver for FireFox is required for selenium to work with FireFox after FireFox 47. Gherkin talks to the step definitions and they then talk to Capybara which then talks to Selenium (if it is set up to use FireFox) which then talks to GeckoDriver. It can be installed using `brew gekodriver`  

**Marionette Server** - Built into the FireFox browser and receives Marionette commands from the GeckoDriver. 

### How the components interrelate
At first I didn't understand how all these dependancies worked together. Here is a good article for further reading:
http://www.erranderr.com/blog/webdriver-ontology.html  
However, if that is TLDR then here is the gist of it.  

In this set-up everything is ran in Ruby. Cucumber is the testing framework that allows us to write tests for browser automation. Gherkin and step definitions come with Cucumber. Gherkin scripts are plain english statements found in a file named like the following \*.feature. Step definitions is where the code lives that Gherkin runs. In this set-up, step definitions are written in Ruby but they could be written in most any language. You can find implementations of Cucumber in all sorts of languages. Each Gherkin plain english statement maps to a step definition. Function definitions for the Gherkin scripts are called step definitions and they can be found in features/step_definitions/\*.rb. 

Inside the step definitions we need an API that allows us to send commands to a browser. We do this using Capybara which is a set of standard commands for browser automation, like click here or fill out this field, etc. It is a wrapper for a web driver. Web drivers are browser specific APIs that allow us to send commands to the browser. Capybara can be configured to use a number of web drivers. There are all sorts of web drivers out there, in this situation we are using the two following web drivers: GeckoDriver (which is uses the Mozilla technology Marionette) and ChromeDriver. GeckoDriver+Marionette allows us to control FireFox and ChromeDriver allows us to control Chrome. 

Ruby based Cucumber is built on top of RSpec. Rspec can also be used on it's own for browser automation if you don't need the Gherkin scripts so that the tests are human readable. If you're already using Cucumber you probably only need RSpec to do unit tests (not browser automation tests) with your back-end Ruby scripts.

I realize that is dense, I hope that clears up what all these tools are and how they work together. If it doesn't make sense then read the link on "webdriver ontology" from above.  

# Anatomy of files and folders 

## Folders 

**features** - this is where all the Cucumber scripts are located.  
**features/step_definitions** - This is where the code evoked by the Gherkin scripts is located.  
**features/support** - This is where the configuration for Cucumber is located.  
**spec** - this is where the RSpec scripts are located.  
**screenshots** - this is where the screenshots from the automated scripts are dumped.  

## Cucumber Files 

**features/support/env.rb** - File which is loaded every time Cucumber is ran. It contains global settings.  
**features/support/.env** - Environmental variables that are loaded by env.rb (this is non-standard for Cucumber) This is so that you can create a .env.dev copy of the file which will not be tracked by Git so that you can separate your local environment variables from the production ones you have in your repository.  

## RSpec files 

**spec/spec_helper.rb** - File that is included globally when running any RSpec test.  
**spec/.env** -  Environmental variables that are loaded by spec_helper.rb (this is non-standard for RSpec) This is so that you can create a .env.dev copy of the file which will not be tracked by Git so that you can separate your local environment variables from the production ones you have in your repository.  

## Cucumber Examples

`cucumber features/greater.feature`  
Example of a hello world 

`cucumber features/search.feature`  
Example of making google search for something

`cucumber features/bank.feature`  
Example of a more complicated Cucumber that logs in to wellsfargo and downloads a statement  

## RSpec Examples

`rspec spec/example-rspec-capybara.rb`  
Example of using Capybara with RSpec

`rspec spec/example-rspec.rb``  
Example of using pure RSpec with Selenium

## Step Definition Notes

Examples on commands that can be used in step definitions:  

To print to console use:  
`puts "some string"`
this calls  
`STDOUT.puts` in features/support/env.rb on the class CustomWorld

To add global custom helper functions  
add methods to the CustomWorld class in features/support/env.rb

To stall a test so you can see what is going on  
`sleep 10`


For more information on configuring your tests with a pre-existing FireFox Profile check out the following thread: [Cannot set FireFox Profile to work with Marrionette]( https://groups.google.com/forum/#!searchin/ruby-capybara/FireFox$20profile$20ssl%7Csort:relevance/ruby-capybara/AyAcBX9-lIE/1LpspvPqCwAJ)  



# Other Notes
**Poltergeist** - A headless driver which integrates Capybara with PhantomJS. It is truly headless, so doesn't require Xvfb to run on your CI server. It will also detect and report any Javascript errors that happen within the page.

**rino** - Cucumber step_definitions can be written using javascript with node `npm install -g cucumber`



edited using : https://pandao.github.io/editor.md/en.html
