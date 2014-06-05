#~ require 'parseexcel'
require 'win32ole'

class Utils
  def initialize
    @@autoitObj = WIN32OLE.new('AutoItX3.Control')
  end
  
  def self.wait_for_window(winTitle, timeOut=10)
    # wait for the window with the title
    autoit = WIN32OLE.new('AutoItX3.Control')
    rs = autoit.WinWait(winTitle, "", timeOut)
    puts rs.to_s
    if (rs == 0) then
      puts "Can not find " + winTitle + " window. Exiting..."
      exit 1
    end
  end
  
  def browse_for_folder(folderName)
    # Assumption is that "Browse for folder" window is active
    autoit = WIN32OLE.new('AutoItX3.Control')
    # select Desktop folder in the tree
    autoit.Send("{HOME}")
    sleep(3)
    # Select "Make new folder" button
    autoit.Send("{TAB}")
    # Click on "Make new folder" button
    autoit.Send("{ENTER}")
    #a.ControlClick("Browser For Folder", "", "&Make New Folder")
    # Enter folder name"
    autoit.Send(folderName)
    # Create new folder
    autoit.Send("{ENTER}")
    # Focus on OK button
    autoit.Send("{TAB}")
    # Click OK buttons
    autoit.Send("{ENTER}")
  end
  
  def open_file_in_dialog_window(winTitle, fileName)
    autoit = WIN32OLE.new('AutoItX3.Control')
    # wait for the window with the title
    rs = autoit.WinWait(winTitle, "", 10)
    puts rs.to_s
    if (rs == 0) then
      puts "Can not find " + winTitle + " window. Exiting..."
      exit 1
    end
    
    # Focus on window with winTitle
    autoit.WinActive(winTitle)
    # Enter file name
    autoit.ControlSetText(winTitle, "", 1148, fileName)
    # Click OK button in Open file dialog box
    autoit.ControlClick(winTitle, "", "&Open")

  end
  
  def self.save_file_in_dialog_window(winTitle, fileName)
    autoit = WIN32OLE.new('AutoItX3.Control')
    wait_for_window(winTitle)
    # Focus on window with winTitle
    autoit.WinActive(winTitle)
    # Enter file name
    autoit.ControlSetText(winTitle, "", "Edit1", fileName)
    # Click OK button in Open file dialog box
    autoit.ControlClick(winTitle, "", "&Save")
    puts fileName
  end
  
  def delay_till_progress_window_exists(title)
    while (@@autoitObj.WinExists(title, "") != 0)
      sleep(1)
    end
  end
  

  
  def self.arr_values_to_hash(header, arr)
    columnNumber = header.length
    i=0
    hash = {}
    for i in 0..columnNumber-1
      hash[header[i]] = arr[i]
    end
    return(hash)
  end
  
  def self.read_data_from_excel(fileName, worksheetIndex=0)
    workbook = Spreadsheet::ParseExcel.parse(fileName)

    worksheet = workbook.worksheet(worksheetIndex)
    #cycle over every row
    arrOfHashes = Array.new
    headerArr = []
    j=0
    worksheet.each { |row|
      i=0
      if row != nil
      arrRow = []
      hashRow = {}
      row.each { |cell|
        contents = nil
        if cell != nil
          contents = cell.to_s('latin1')
          #puts "Row: #{j} Cell: #{i} #{contents}"      
        end
        if j == 0
          headerArr.push(contents) 
        else
          arrRow.push(contents)
        end  
        i = i+1
      }
      if j != 0
        hashRow = arr_values_to_hash(headerArr, arrRow)
        arrOfHashes.push(hashRow)
      end
      j = j+1
      end
    }
    return(arrOfHashes)
  end
  
  def self.nil_to_empty_str(dataHash)
    dataHash.each{|key, value|
       dataHash[key] = "" if value == nil
    }
    return(dataHash)
  end
  
  def self.wait_for_expected_object(brObj, method, how, what, timeOut=10)
  
    existsCommand = "brObj." + method + "(" + how + "," + what + ").exists?"

    startTime = Time.now
    while (! eval existsCommand) 
      currTime = Time.now - startTime

      if currTime.to_i > timeOut
        puts "The object " + existsCommand + " Not found in " + timeOut.to_s + " seconds"
        break
      end
      sleep 1
      return(currTime)
    end
  
  end
  
  def self.number_to_date_str(num)

    num = num.to_i if num != nil
    if num == nil
      dateStr = ""
    elsif num == 0
      dateStr = Date.today.strftime("%m/%d/%Y")
    elsif num > 0
      dateStr = (Date.today + 1).strftime("%m/%d/%Y")
    else
      dateStr = ""
    end
    return(dateStr)
  end

  def self.manage_popup_window(winTitle, button, timeOut = 2)
    
    popup = Thread.new{
      loop do
        puts "I am here in a thread " + winTitle + " - "
        sleep timeOut
        autoit=WIN32OLE.new('AutoItX3.Control')
        # Set option to Match any substring in the title
        autoit.AutoItSetOption("WinTitleMatchMode", 2)
        rs = autoit.WinExists(winTitle)
        if (rs == 1)
          puts winTitle + " " + button
          autoit.WinActivate(winTitle)
          autoit.ControlClick(winTitle, "", button)
        else
          puts winTitle + " Popup not found"
        end
      end
    }
 
    return popup
  end

  def self.get_test_home(file)
    currDir = File.dirname(file)
    Dir.chdir(currDir)
    test_home_dir = Dir.pwd.gsub('/','\\')
    return(test_home_dir)
  end
  
end # End of class Utils

testUtil = false
#~ fileName = "C:\\work\\Projects\\Testing\\recordshare\\data\\ItemsTestData.xls"
#~ #
#~ arr = Utils.read_data_from_excel(fileName, 2)
#exit

if testUtil then
  folderName = 'test123'
  winTitle = "Choose an XPS document"
  fileName = 'C:\Work\Marbles\Testing\Blog.xps'
  title = 'File loading in progress'
 require 'win32ole'
 a = Utils.new()
 a.delay_till_progress_window_exists(title)
 puts "CONTINUE"
 #a.open_file_in_dialog_window(winTitle, fileName)
end
