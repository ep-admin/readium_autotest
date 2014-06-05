$LOAD_PATH << './lib'

require 'test_logger'
require 'web_ui_test2'


class BrowserViewer

	def initialize(browserObj, configObj, logObj)

		@browser =browserObj
		@config = configObj
		# @log =logObj
		@Log = TestLogger.new(@config.get_value('RESULTS_HOME'))
	end

	def Log
		@Log
	end


	def add_book2library(book)

		checkDetails= File.exists? book 

		puts "Does the file exist: " + (File.exists? book).to_s
		if ((checkDetails)==true)
			actionStatus = "0"
			# checkDetails = 'This file exists'
			@browser.button(:id, "addbutt").click 
			@browser.file_field(:id, "epub-upload").set(book)
			wait_utill_upload_progress_bar_exists()
		else
			actionStatus = "1"
			checkDetails = 'This file Does not exist'
			@Log.write2log(actionStatus, book, checkDetails, '')
		end
		return actionStatus

	end
	

	def open_book(title)


		b= @browser.div(:class, "row library-items").button(:title, title)
		b.wait_until_present
		b.click
		@Log.write2log('','','','')


		if wait4page2render()== true
			status = 'OK'
			@Log.write2log(status, 'Opened book ', title, '')
		else 
			status = 'NOTOK'
			@Log.write2log(status, 'Cannot Open book ', title, '')
		end


	end

	def goto_library()

		@browser.div(:class, "btn-group navbar-right").button(:title, "Library [b]").click
	end
	def goto_page(pageNum)
		pageNum.times do 
			goto_nextpage()
		end
		@Log.write2log('OK','Go to page ', pageNum, '')
	end

	def goto_toc_item(item)
		@browser.button(:id, "tocButt").click 
		toc = @browser.div(:id, "readium-toc-body").a(:text, item)
		if (toc.exists? == true)
			checkDetails = 'Navigate to TOC item'
			actionStatus = 'OK'
			status = 0
			toc.click
			@Log.write2log(actionStatus, 'Go to TOC', item, '')
		else 
			checkDetails = 'Cannot Navigate to TOC item'
			actionStatus = 'NOTOK'
			status =1
			@Log.write2log(actionStatus, 'Go to TOC', item, checkDetails)
		end
		sleep 4
		#close the TOC drawer
		@browser.button(:id, "tocButt").click
		
		return status
	end

	def goto_first_page_of_book()
		@browser.button(:id, "tocButt").click 
		firstitem  = @browser.div(:id, "readium-toc-body").li(:index, 0).text
		firstitemlink = @browser.div(:id, "readium-toc-body").a(:text, firstitem)
		firstitemlink.click
		@browser.button(:id, "tocButt").click 
	end
	
	def goto_nextpage()
		b= @browser.div(:id, "reading-area").button(:id, "right-page-btn")
		b.wait_until_present
		b.click
	end


	def goto_previouspage()
		@browser.div(:id, "reading-area").button(:id, "left-page-btn").click
	end

	#~ Toggle with Thumbnail view.
	def switchto_listview()
		@browser.button(:class, "btn icon-list-view").click
	end


	def switchto_thumbnailview()
		@browser.button(:class, "btn icon-thumbnails").click
	end


	def wait_utill_upload_progress_bar_exists(maxTime2wait = 120)
		sleep 3
		startTime = Time.now

		while(@browser.div(:id, "progress-bar").exist? and @browser.div(:id, "progress-bar").visible?)
			sleep 2
			action = "wating for epub uploading"
			@Log.write2log(action, '','','')

			break if (Time.now - startTime).to_i > maxTime2wait
		end
	end

	def check_expected_text(action, exp_text)
		b= @browser.div(:class => "reflowable-content-frame")
		c= b.iframe(:id => "epubContentIframe")
		if (c.p.exist? == true)
			d= c.p.text
		end

		if @browser.text.include?"#{exp_text}" then
			actionStatus = 'OK'
	    	# puts "Expected Text exists" 
	    	status = 0
	    	checkDetails = 'FOUND in the page'
	  	else
	    	actionStatus = 'NOTOK'
	    	# puts "Expected Text does not exist" 
	    	status = 1
	    	checkDetails = 'NOT FOUND in the page'
	    	# @Log.write2log(actionStatus, action, exp_text, checkDetails)

	  	end
	  	@Log.write2log(actionStatus, action, checkDetails, exp_text)
	  	return status 

	  	#puts "Expected Text exists in page?" + " " + actionStatus.to_s
	  	#puts actionStatus
	end

	def wait4page2render(maxTime2wait=20)
		startTime = Time.now
		@browser.div(:id, "reading-area").wait_until_present
		timer = ((Time.now - startTime).to_s + "s")
		# @Log.write2log('Page loading in', timer, '','')
		sleep 2
		return true
	end
	

end