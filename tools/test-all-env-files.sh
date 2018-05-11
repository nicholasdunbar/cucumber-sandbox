#! /bin/bash 

#this will go through all the configurations and test them on each setup

#test cucumber
webdriver_path='/Applications/Firefox Nightly.app/Contents/MacOS/firefox'
browsers=(CHROME FIREFOX FIREFOX-HARDCODED-PROFILE FIREFOX-SAVED-PROFILE SAFARI SAFARI-TECHNOLOGY-PREVIEW);
executable=(default default default default default default);

test_name='Cucumber'
for j in {0..1}; 
  do 
  for i in {0..5}; 
    do 
    echo "${test_name} Test# ${j} : ${i}";
    echo "TIMEOUT=10
BROWSER=${browsers[$i]}
ACCEPTALLCERTS=true
FFPROFILEPATH=default
FIREFOXPATH=${executable[$i]}
USERAGENT=Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1" > features/support/.env.test;
    cat features/support/.env.test;
    cucumber features/search.feature TARGET=test > test-all.output 2>&1;
    isError=$(cat test-all.output | xargs -0 | grep -E 'Fail');
    if [[ -z $isError ]]; then
      echo "no errors";
      echo "";
    else 
      cat test-all.output;
    fi
    rm test-all.output;
    rm features/support/.env.test;
    done
  executable[1]=$webdriver_path
  executable[2]=$webdriver_path
  executable[3]=$webdriver_path
done

#test rspec and capybara
test_name='Rspec+Capybara'
for j in {0..1}; 
  do 
  for i in {0..5}; 
    do 
    echo "${test_name} Test# ${j} : ${i}";
    echo "TIMEOUT=10
BROWSER=${browsers[$i]}
ACCEPTALLCERTS=true
FFPROFILEPATH=default
FIREFOXPATH=${executable[$i]}
USERAGENT=Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1" > spec/.env.test;
    cat spec/.env.test;
    TARGET=test rspec spec/example-rspec-capybara.rb > test-all.output 2>&1;
    isError=$(cat test-all.output | xargs -0 | grep -E 'Fail');
    if [[ -z $isError ]]; then
      echo "no errors";
      echo "";
    else 
      cat test-all.output;
    fi
    rm test-all.output;
    rm spec/.env.test;
    done
  executable[1]=$webdriver_path
  executable[2]=$webdriver_path
  executable[3]=$webdriver_path
done

#test rspec and selenium
test_name='Rspec+Selenium'
for j in {0..1}; 
  do 
  for i in {0..5}; 
    do 
    echo "${test_name} Test# ${j} : ${i}";
    echo "TIMEOUT=10
BROWSER=${browsers[$i]}
ACCEPTALLCERTS=true
FFPROFILEPATH=default
FIREFOXPATH=${executable[$i]}
USERAGENT=Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1" > spec/.env.test;
    cat spec/.env.test;
    TARGET=test rspec spec/example-rspec.rb > test-all.output 2>&1;
    isError=$(cat test-all.output | xargs -0 | grep -E 'Fail');
    if [[ -z $isError ]]; then
      echo "no errors";
      echo "";
    else 
      cat test-all.output;
    fi
    rm test-all.output;
    rm spec/.env.test;
    done
  executable[1]=$webdriver_path
  executable[2]=$webdriver_path
  executable[3]=$webdriver_path
done
