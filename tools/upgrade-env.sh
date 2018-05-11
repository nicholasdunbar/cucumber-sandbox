#! /bin/bash

#as evergreen browsers keep changing you will have to keep up with the new 
#versions of webdrivers and Ruby gems. 

#this script upgrades the dependancies  

#remove previous version
brew uninstall geckodriver;
#install new version
brew install geckodriver;
#remove previous version
brew uninstall chromedriver;
#extend brew to have access to open source community of brew formulae 
brew tap caskroom/cask;
#remove previous
brew cask uninstall chromedriver;
#install new version
brew cask install chromedriver;
bundle update selenium-webdriver;
bundle update cucumber;
bundle update capybara;
rubyGemset=$(cat .ruby-gemset);
rvm gemset empty "$rubyGemset";
gem install bundler;
bundler install;
