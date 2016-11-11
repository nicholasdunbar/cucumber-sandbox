# Using cucumber, rspec and capybara to login to site and download files 


##How to set up the environment
run the bash script set-up-env.sh

## Dependancies
**Cucumber** - A Ruby gem that allows mapping Ruby functions to plain text in a "features" file which will run behavior driven tests in the browser.
**Gherkin** - The .feature files that cucumber uses which allows plain english grammars to be mapped to functions in step_definitions/
**Rspec** - A Ruby defined DSL (Domain Specific Language) that can be used to run behavior driven tests in the browser you can also use it to do unit tests on Ruby code if you are using Ruby in your application.
**Capybara** - A wrapper for webdrivers. Use this if you want to use one API that maps to both Chrome and Firefox. It can also be used for headless testing. Documentation found at http://www.rubydoc.info/github/jnicklas/capybara/master
**Marionette** - GeckoDriver for FireFox. can be installed using `brew gekodriver`



## Examples

### Step Definition Notes

Examples on commands that can be used in step definitions
to print to console use:  
STDOUT.puts "test global vars"

## Notes
**Poltergeist** - A headless driver which integrates Capybara with PhantomJS. It is truly headless, so doesn't require Xvfb to run on your CI server. It will also detect and report any Javascript errors that happen within the page.

edited using : https://pandao.github.io/editor.md/en.html
