require 'rubygems'
#~ require 'watir'
#~ require 'watir-webdriver'

require 'get_config_data'
require 'test_logger'




class WebUITest2
	def initialize(filename)
	      # read config file
	      @config = GetConfigData.new(filename)
	      # create log object
	      # @testLog = TestLogger.new(@config.get_value('RESULTS_HOME'))
	end

  	def get_log_obj
    	return @testLog
  	end
  
  
  	def get_browser_obj
    	return @browserObj
  	end
  
  	def get_config_obj
    	return @config
  	end

      
    def browserObj
		@browserObj
	end
	
	def config
		@config
	end
    
	def testLog
		@testLog
	end
	
	def get_browser_type(browser_type)
		browser_type = "ie" if (browser_type == "" or browser_type == nil)
		browser_type = browser_type.downcase
		if browser_type  == "ff" or  browser_type == "firefox"            
		    browserType = "firefox"
		elsif browser_type == "ie"
		    browserType = "ie"
		elsif browser_type == "chrome"
		    browserType = "chrome" 
		else 
		  raise "Unknown browser type: " + browser_type
		  @testLog.write2log('NOTOK', 'get value of', 'RBA_BROWSER', browser_type + 'is unknown browser type')
		end
				
		return(browserType)
	end
	
	#~ watir-webdriver is not good as watir (at least for IE) so in case of IE watir will be used
	def start_browser(paramArray)
		browserType = get_browser_type(@config.get_value('BROWSER'))
		if (browserType.downcase == "ie" and @config.get_value('USE_WATIR').downcase == 'yes')
			require 'watir'
			@browserObj = Watir::Browser.new
		else
			require 'watir-webdriver'
			#~ @browserObj = Watir::Browser.new(browser = browserType, :switches => %w[--load-extension=C:\\work\\Projects\\Testing\\readium\\build\\chrome-app])
			puts paramArray[0]
			@browserObj = Watir::Browser.new(browser = browserType, :switches => paramArray)

		end
				
	end
	
	
	def start_test(exp_text="")
		# write config info to log file
		# @testLog.add_header2log(@config.get_hash)


		# get browser type from config file and convert it to the proper value for creating browser object
		#~ browserType = get_browser_type(@config.get_value('BROWSER'))
		# start browser and navigate to url
		#~ @browserObj = Watir::Browser.new(browser = browserType)


		switches = []
		switches << @config.get_value('BUILD_HOME')
		switches[0] = "--load-extension=" + switches[0]
		start_browser(switches)

		#~ resizes browser to configurable dimensions
		width = @config.get_value('WIDTH')
		height = @config.get_value('HEIGHT')
		fix_size_browser(width, height)

		#~ loads the extention url in the browser
		url = @config.get_value('URL')
		@browserObj.goto(url)
		#@@browserObj.wait
		#@@browserObj.bring_to_front()
		# Check expected test in page
		status = check_text_in_page('GET default page', url, exp_text)

		return status
	end

	def fix_size_browser(width, height)
		@browserObj.window.resize_to(width, height)
		return true
	end

	
	#  check_text_in_page cheks whether a text exists in a page. 
	# The text existance is a criteria that a page is open successfully
	def check_text_in_page(action, object, exp_text)
	  if @browserObj.text.include?"#{exp_text}" then
	    actionStatus = 'OK'
	    status = 0
	  else
	    actionStatus = 'NOTOK'
	    status = 1
	    checkDetails = exp_text + ' NOT FOUND in the page'
	  end
	  # @testLog.write2log(actionStatus, action, object, checkDetails)
	  return status
	end
	


	
end #End of WebUITest2 class

testWebUI = false
if testWebUI
	configFile = "C:\\work\\Projects\\Testing\\activetextbook\\activetextbook.config"
	aTest = WebUITest2.new(configFile)
	
	aTest.start_test("Log In")
	browser = aTest.browserObj
	browser.links.each{|link| puts link.text}
end
