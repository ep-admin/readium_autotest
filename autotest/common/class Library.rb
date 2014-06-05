# class Library 
# 	def initialize(browserObj, configObj)
# 		@browser = browserObj
# 		@config = configObj
# 	end

# 	def log
# 		@log
# 	end

# 	def goto_page(pageNum)
# 		pageNum.times do 
# 			goto_nextpage()
# 		end
# 		# @Log.write2log('Navigate to page ', pageNum, '', '')
# 	end

# 	def goto_toc_item(item)
# 		@browser.button(:id, "tocButt").click 
# 		toc = @browser.div(:id, "readium-toc-body").a(:text, item)
# 		if (toc.exists? == true)
# 			checkDetails = 'Navigate to TOC item'
# 			actionStatus = 'OK'
# 			status = 0
# 			toc.click
# 		else 
# 			checkDetails = 'Cannot Navigate to TOC item'
# 			actionStatus = 'NOTOK'
# 			status =1
# 		end
# 		sleep 4
# 		#close the TOC drawer
# 		@browser.button(:id, "tocButt").click
# 		# @Log.write2log(actionStatus, 'Go to TOC', item, checkDetails)
# 		return status
# 	end

# 	def goto_nextpage()
# 		b= @browser.div(:id, "reading-area").button(:id, "next-page-btn")
# 		b.wait_until_present
# 		b.click
# 	end


# 	def goto_previouspage()
# 		@browser.div(:id, "reading-area").button(:id, "previous-page-btn").click
# 	end

# 	def goto_library()

# 		@browser.div(:class, "btn-group navbar-right").button(:title, "Library [b]").click
# 	end


# end
