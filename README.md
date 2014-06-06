readium_autotest
================

Autotest for readium browser project
##Environment Setup
###Step 1:#####Install RVM & Ruby *curl -L get.rvm.io | bash -s stable

source ~/.rvm/scripts/rvm
$ rvm list known
$rvm install 1.9.3-p545*Mostly, ruby comes pre installed in the Mac OS. To check the version of ruby you are running, go to command line and type:
 *$ ruby –v*. 
Just in case the version is updated to the latest ruby version, in order to run this autotest type we need 1.9.3. So, so to use this version: 
*$ rvm use 1.9.3*
###Step 2:#####Install the required gems
Youreate a seperate gemset environment to install your gems in. 

*$ rvm gemset create readium_autotest*

*$ rvm gemset use readium_autotest*Before we install the gems, you need to make sure that you have installed the **command line developer tools**. You can do this manually or to install, type to Terminal:
*$ xcode-select --install*. 
Click ‘install’ on the popup that appears asking you to install the command line developer tools**To install the gems go to Terminal and execute:** 
*$ gem install watir-webdriver**$ gem install rubyXL 2.5.1*<!--*$ gem install zip 2.0.2*
-->###Step 3: 
To drive Chrome, you need **Homebrew**. To install it, paste this into Terminal. You will have to type your password during installation.*$ ruby -e "$(curl -fsSL*
If already installed then: 
*$ brew update*To check if everything is set up correctly, type brew doctor:
*$ brew doctor*Now we have to install something called **ChromeDriver** executable. 
*$ brew install chromedriver*##Description:The readium autotest is the browser autotest that loads the Readium extention to the Chrome browser and teststhe web application.
 * It loads a readium extention into a fixed browser sized window* Goes to the loaded extention on the Library page.* Add epub books. * Opens the books.* Navigate to page/s* Navigate to Table of content/s items.* Verifies expected text existence upon two modules: navigation to page and navigation to TOC.* Returns back the LibraryThe way user can maniupulate which book and text verification to check, is by editing data in the **xlsx** file.  It has three spread sheets: **Books** (contains the data for the books with Title); **Text** (contains the title, expected text and page number it could be found on);and  **TOC** (contains the expected text and table of content item it could be found on). There is also a **config** file that contains the data that each user can manipulate in order to run their test.After the execution of the test each time, there is a **log file** created in the **res** folder. It is a **txt file** that records the basic results of the test execution for now. ###To run the test:
In order to run the test, make sure the fields in the config file are set accordingly. Go to the (autoreadium.rb.config) file for more directions. 

Build the **chrome-app** and set the path of the packed extension in the **BUILDHOME** field of the config file.  Configure the file. 
Go to the Terminal, navigate to the autotest directory and type: 
*$ ruby autoreadium.rb*
