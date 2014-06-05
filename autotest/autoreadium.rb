$LOAD_PATH << './utils'
$LOAD_PATH << './lib'
$LOAD_PATH << './common'

require 'readium_test'
require './data/readium_data_desc'
require 'browser_viewer'


configFileName = "./autoreadium.rb.config"

(aTest, browser, config, log) = ReadiumTest.start_wtest(configFileName)


# Should be a method that checks where initila page is loaded properly
browser.div(:id, "app-container").wait_until_present
browser.refresh

booksDataHashes = ReadiumTest.get_test_data(File.dirname(File.expand_path($0)) + "/"  + config.get_value("DATAFILE"), $Wb["Books"])
TextDataHashes = ReadiumTest.get_test_data(File.dirname(File.expand_path($0)) + "/"  + config.get_value("DATAFILE"), $Wb["Text"])
TOCDataHashes = ReadiumTest.get_test_data(File.dirname(File.expand_path($0)) + "/"  + config.get_value("DATAFILE"), $Wb["TOC"])

ReadiumEditor = BrowserViewer.new(browser, config, log)
# library = Library.new(browser, config, log)


# puts booksDataHashes
# puts TextDataHashes
# puts TOCDataHashes




bookHome = config.get_value("BOOK_HOME")
num=1 
booksDataHashes.each{|el|
  bookFullPathName = bookHome  + el["Book"]
  puts bookFullPathName

  booktitle = el["Title"]

  puts "now testing book "  + bookFullPathName + " with title: " + booktitle
  puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"


  ReadiumEditor.add_book2library(bookFullPathName)

  	TextDataHashes.each{|txt|
  		texttitle = txt["Title"]
    	pagenum = (txt["Page"])
		expectedtext = txt["ExpectedText"]
		if booktitle == texttitle
			n= num.to_s
			title = "(" + n + ") " + booktitle
		    ReadiumEditor.open_book(title)
		    #sleep 3
		    ReadiumEditor.goto_page(pagenum)
		    # library.goto_page(pagenum)
		    puts "Checking if Expected Text ' " + expectedtext + " ' exists in page number " + pagenum.to_s + "?"
		    # ReadiumEditor.check_expected_text(expectedtext)
		    status= ReadiumEditor.check_expected_text('Expected Text', expectedtext)
		    sleep 2
		  	puts status
		  	ReadiumEditor.goto_first_page_of_book()
		    ReadiumEditor.goto_library()
		    sleep 2
		end
	
	}

	TOCDataHashes.each{|tochash|
		toctitle = tochash["Title"]
		tocitem = tochash["TOCItem"]
		expectedtext = tochash["ExpectedText"]
		if booktitle == toctitle
			# z=1
			n= num.to_s
			title = "(" + n + ") " + booktitle
			ReadiumEditor.open_book(title)
			sleep 5
			# tocitem= "chapter0" + z.to_s
			st = ReadiumEditor.goto_toc_item(tocitem)
			# st = library.goto_toc_item(tocitem)
			puts "Checking if Expected Text ' " + expectedtext + " ' exists in TOC's " + tocitem + "?"
			if st ==0
			    # ReadiumEditor.check_expected_text(expectedtext)
			    status = ReadiumEditor.check_expected_text('Expected Text', expectedtext)
			else 
				puts "Cannot check expected text"
			end 
			puts status
			ReadiumEditor.goto_library()
			 # z=z+1
		end
	}
	
	num=num+1

}
  
 



#~ uploading a url
def add_book2library_fromurl(url)
	
	@browser.button(:id, "addbutt").click  
	@browser.text_field(:id, "url-upload").set(url)
end

#~ Open already created epub file

#~ via title 


# #~ via tabindex

def openfileusingtabindex(tabindex)
	b = @browser.div(:class, "row library-items")
    d = b.button.attribute_value('tabindex')
	if d=="101"
		b.button.click
	end
end





#~ open the settings menu

def openSettings()
	@browser.button(:id, "settbutt1").click 
end

#~ close the settings menu /.click would not work 
def closeSettings()
	c= @browser.div(:class, "modal-body")
    d= c.button(:id, "closeSettingsCross")
	d.click
end










