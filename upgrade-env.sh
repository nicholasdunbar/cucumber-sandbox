#! /bin/bash

#this script upgrades the dependancies  

brew uninstall geckodriver;
brew install geckodriver;
brew uninstall chromedriver;
#extend brew to have access to open source community of brew formulae 
brew tap caskroom/cask;
brew cask uninstall chromedriver;
brew cask install chromedriver;
bundle update selenium-webdriver;
bundle update cucumber;
bundle update capybara;
