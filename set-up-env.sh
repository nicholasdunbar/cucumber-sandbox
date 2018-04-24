#! /bin/bash

#this script installs the dependancies

#Check if ruby and rvm is installed
command -v rvm >/dev/null 2>&1 || { echo >&2 "Attempting to install ruby and rvm"; curl -sSL https://get.rvm.io | bash -s stable --ruby; };
command -v rvm >/dev/null 2>&1 || { echo >&2 "Ruby and rvm installation failure"; exit 1; };
#Check if gem is installed
command -v gem >/dev/null 2>&1 || { echo >&2 "I require gem but it's not installed. You can get it here https://rubygems.org/pages/download"; exit 1; };
#install perscribed ruby version
rubyVersion=$(cat .ruby-version);
rvm install "$rubyVersion" 2>/dev/null;
rubyGemset=$(cat .ruby-gemset);
rvm gemset create "$rubyGemset";

#install bundler
gem list | grep -E "^bundler$" >/dev/null 2>&1 || { echo >&2 "Attempting to install bundler"; gem install bundler; };
gem list | grep -E "^bundler$" >/dev/null 2>&1 || { echo >&2 "bundler installation failure"; exit 1; };

#check to see if Homebrew (brew) is installed
isBrew=$(brew -v | xargs -0 | grep -E 'Homebrew');
if [[ -z $isBrew ]]; then
  echo "Homebrew is not installed. Attempting to install. If install fails check https://brew.sh";
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
else
  echo "Homebrew https://brew.sh is already installed";
fi
#install brew cask 
#extend brew to have access to open source community of brew formulae 
brew tap caskroom/cask;

#install Marionette for Firefox
isGeckodriver=$(brew list | xargs -0 | grep -E 'geckodriver');
if [[ -z $isGeckodriver ]]; then
  echo "Installing Firefox Marionette geckodriver";
  brew install geckodriver;
else
  echo "Firefox Marionette geckodriver is already installed";
fi
#install chromedriver for Chrome
isChromedriver=$(brew list | xargs -0 | grep -E 'chromedriver');
if [[ -z $isChromedriver ]]; then
  echo "Installing chromedriver";
  brew cask install chromedriver;
else
  echo "chromedriver is already installed";
fi
#install rubygems
echo "installing ruby gems from Gemfile"
bundle install;
#create dev settings
cat ./features/support/.env > ./features/support/.env.dev;
cat ./spec/.env > ./spec/.env.dev;
