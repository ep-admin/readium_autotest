$LOAD_PATH << '../utils'
$LOAD_PATH << '../lib'
$LOAD_PATH << '.'

require 'web_ui_test2'
#~ require 'excel_test_utils'
require 'excel_utils'

class ReadiumTest 
	def self.get_test_data(excelfullPathDataFileName, worksheetNumberName)
		#~ dataArray = ExcelTestUtils.worksheet2array(excelfullPathDataFileName, worksheetNumberName)
		dataArray = ExcelUtils.worksheet2array(excelfullPathDataFileName, worksheetNumberName)
		arrayOfHashes = ExcelUtils.data_array2array_of_hashes(dataArray)
		return(arrayOfHashes)
	end
	
	def self.get_array_of_test_obj(aTest, browser, config, log)
		testObjArray = []
		testObjArray << aTest
		testObjArray << browser
		testObjArray << config
		testObjArray << log		
	end
	
	def self.start_wtest(configFileName)

		aTest = WebUITest2.new(configFileName)
		aTest.start_test()
		browser = aTest.get_browser_obj
		config = aTest.get_config_obj
		log = aTest.get_log_obj

		testObjArray = get_array_of_test_obj(aTest, browser, config, log)
		
		return(testObjArray)
	end
	
end
