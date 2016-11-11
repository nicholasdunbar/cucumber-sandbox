# Playing with cucumber, rspec and capybara 


##How to set up the environment
run the bash script set-up-env.sh

## Dependancies
**Cucumber** - A Ruby gem that allows mapping Ruby functions to plain text in a "features" file which will run behavior driven tests in the browser.

**Gherkin** - The .feature files that cucumber uses which allows plain english grammars to be mapped to functions in step_definitions/

**Step Definitions** - The functions programmed in ruby using the capybara functions that are called by Gherkin scripts.

**Rspec** - A Ruby defined DSL (Domain Specific Language) that can be used to run behavior driven tests in the browser you can also use it to do unit tests on Ruby code if you are using Ruby in your application.

**Capybara** - A wrapper for webdrivers. Use this if you want to use one API that maps to both Chrome and Firefox. It can also be used for headless testing. Documentation found at http://www.rubydoc.info/github/jnicklas/capybara/master

**Marionette** - GeckoDriver for FireFox which is required for selenium to work. Gherkin talks to the step definitions and they then talk to capybara which then talks to selenium (if it is set up to use that driver) which then talks to GeckoDriver if you are using FireFox in capybara. It can be installed using `brew gekodriver`



## Examples

### Step Definition Notes

Examples on commands that can be used in step definitions
to print to console use:  
STDOUT.puts "test global vars"

## Notes
**Poltergeist** - A headless driver which integrates Capybara with PhantomJS. It is truly headless, so doesn't require Xvfb to run on your CI server. It will also detect and report any Javascript errors that happen within the page.

edited using : https://pandao.github.io/editor.md/en.html
