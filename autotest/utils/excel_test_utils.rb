require 'win32ole'

class ExcelTestUtils
  def self.worksheet2array(excelDataFileName, worksheetNumberName)
    excel = WIN32OLE:: new('excel.Application') 
    workbook = excel.Workbooks.Open(excelDataFileName) 
    worksheet = workbook.Worksheets(worksheetNumberName)
    #worksheet.Select
    
    dataArray = worksheet.UsedRange.Value 
    excel.Quit
    return dataArray
  end
  
  # converts 2-dimensional array to array of hashes where 1st row is headers (hash keys)
  def self.data_array2array_of_hashes(dataArray)
      headers = dataArray.shift  # 1st row is headers
      #ArrayOfHashes = Array.new(dataArray.length, Hash.new)
      arrayOfHashes = Array.new
      for i in 0..dataArray.length - 1
       dataHash = {}
        for j in 0..headers.length - 1
          dataHash[headers[j]] = dataArray[i][j]
        end
        arrayOfHashes << dataHash
    end
    return arrayOfHashes
  end
  
  # converts 2-dimesional array to array of hashes where the 1st column is headers (hash keys)
  def self.data_array2array_of_hashes_1st_column_is_headers(dataArray)
      arrayOfHashes = Array.new
      columns = []
      for i in 0..dataArray.length - 1
          columns << dataArray[i].length
      end
      for col in 1..columns.max - 1
          dataHash = {}
            for row in 0..dataArray.length - 1
              dataHash[dataArray[row][0]] = dataArray[row][col]
            end
          arrayOfHashes << dataHash
        end
        
      return(arrayOfHashes)
  end
  
  def self.add_new_sheet(excelFileName, sheetName, existingSheet, before=true)
    excel = WIN32OLE:: new('excel.Application') 
    workbook = excel.Workbooks.Open(excelFileName)
    if before
      worksheet = workbook.Worksheets.Add({"Before" => workbook.Worksheets(existingSheet)})
    else
      worksheet = workbook.Worksheets.Add({"After" => workbook.Worksheets(existingSheet)})      
    end
    
    excel["DisplayAlerts"] = 0  # Repleace if file already exists
    workbook.SaveAs(excelFileName)
    excel.Quit
  end
  
  
  def self.create_excel_file(excelFileName, sheetArray)
    excel = WIN32OLE:: new('excel.Application') 
    #workbook = excel.Workbooks.Create(excelDataFileName)
     excel["DisplayAlerts"] = 0  # Repleace if file already exists

        workbook = excel.Workbooks.Add()

    workbook.SaveAs(excelFileName)
    excel.Quit
  end
  
  def self.add_headers2excel_file(excelFileName, worksheetNumberName, headers)
    begin
        excel = WIN32OLE:: new('excel.Application') 
        workbook = excel.Workbooks.Open(excelFileName) 
        worksheet = workbook.Worksheets(worksheetNumberName)
        
        for i in 0..headers.length
          worksheet.Cells(1, i+1).Font["FontStyle"] = "Bold"
          worksheet.Cells(1, i+1).Value = headers[i]
        end
        worksheet.Columns("A").AutoFit()
        worksheet.Columns("B:C")["ColumnWidth"] = 30
        worksheet.Columns("D")["ColumnWidth"] = 40
        excel["DisplayAlerts"] = 0  # Repleace if file already exists
        workbook.SaveAs(excelFileName)
        excel.Quit
    rescue
        # In case any error end the excel process otherwise won't be able to write in the file later since the file will be locked
        puts $!
        excel.Quit    
    end
  end
  
  def self.add_background_color2cells(excelFileName, worksheetNumberName=1)
    # Geting indexes of colors that could be used 
    begin
        excel = WIN32OLE:: new('excel.Application') 
        workbook = excel.Workbooks.Open(excelFileName) 
        worksheet = workbook.Worksheets(worksheetNumberName)
        #~ worksheet.Range("A1:D1").Interior.ColorIndex=27 # change color to Yellow

        for i in 1..56
          worksheet.Cells(i, 1).Interior.ColorIndex= i
          worksheet.Cells(i,1).Value = i
        end
        
        excel["DisplayAlerts"] = 0  # Repleace if file already exists
        workbook.SaveAs(excelFileName)
        excel.Quit
    rescue
      # In case any error end the excel process otherwise won't be able to write in the file later since the file will be locked
      puts $!
      excel.Quit
    end
  end
  
  
  def self.add_array2row(excelFileName, worksheetNumberName, array)
    begin
        excel = WIN32OLE:: new('excel.Application') 

        workbook = excel.Workbooks.Open(excelFileName) 
        worksheet = workbook.Worksheets(worksheetNumberName)
        
        # Find the last row
        lastRow = worksheet.UsedRange.Rows.Count

        for i in 0..array.length - 1
          worksheet.Cells(lastRow + 1, i+1).Value = array[i]
          # Set background coror to red in case 1st element (status) is NOTOK
          if array[0] == "NOTOK"
            worksheet.Cells(lastRow + 1, i+1).Interior.ColorIndex= 46  # set cell background to Red color
          end
        end
        
        excel["DisplayAlerts"] = 0  # Repleace if file already exists
        workbook.SaveAs(excelFileName)
        excel.Quit
    rescue
      # In case any error end the excel process otherwise won't be able to write in the file later since the file will be locked
      puts $!
      excel.Quit    
    end
  end
  
  def self.add_two_dimensional_array_to_file(excelFileName, worksheetNumberName, array)
    begin
        excel = WIN32OLE:: new('excel.Application') 

        workbook = excel.Workbooks.Open(excelFileName) 
        worksheet = workbook.Worksheets(worksheetNumberName)
        
        # Find the last row
        lastRow = worksheet.UsedRange.Rows.Count
        
        for i in 0..array.length - 1
          for j in 0..array[i].length - 1
              worksheet.Cells(lastRow + 1 + i, j+1).Value = array[i][j]
          end
        end
        
        excel["DisplayAlerts"] = 0  # Repleace if file already exists
        workbook.SaveAs(excelFileName)
        excel.Quit
    rescue
      # In case any error end the excel process otherwise won't be able to write in the file later since the file will be locked
      puts $!
      excel.Quit       
    end
        
  end
  
  def self.change_cell_background_color(excelFileName, worksheetNumberName, columnIndex, cellValue, colorIndex=3)
        # Default color is red (3)
    begin
        excel = WIN32OLE:: new('excel.Application') 

        workbook = excel.Workbooks.Open(excelFileName) 
        worksheet = workbook.Worksheets(worksheetNumberName)
        # Find the last row
        lastRow = worksheet.UsedRange.Rows.Count
        for i in 1..lastRow
          if worksheet.Cells(i, columnIndex).Value == cellValue
            worksheet.Cells(i, columnIndex).Interior.ColorIndex = colorIndex
          end
          
        end
        excel["DisplayAlerts"] = 0  # Repleace if file already exists
        workbook.SaveAs(excelFileName)
        excel.Quit
    rescue
      # In case any error end the excel process otherwise won't be able to write in the file later since the file will be locked
      puts $!
      excel.Quit     
    end
  end
  
  def self.change_row_background_color(excelFileName, worksheetNumberName, columnIndex, cellValue, colorIndex=3)
        # Default color is red (3)
    begin
        excel = WIN32OLE:: new('excel.Application') 

        workbook = excel.Workbooks.Open(excelFileName) 
        worksheet = workbook.Worksheets(worksheetNumberName)
        # Find the last row
        lastRow = worksheet.UsedRange.Rows.Count
        for i in 1..lastRow
          if worksheet.Cells(i, columnIndex).Value == cellValue
            for j in 1..worksheet.Rows(i).Columns.Count
              worksheet.Cells(i, j).Interior.ColorIndex = colorIndex
              break if worksheet.Cells(i, j).Value == nil
            end
          end
          
        end
        excel["DisplayAlerts"] = 0  # Repleace if file already exists
        workbook.SaveAs(excelFileName)
        excel.Quit
    rescue
      # In case any error end the excel process otherwise won't be able to write in the file later since the file will be locked
      puts $!
      excel.Quit     
    end
  end  
  
end


test = false
if test == true
  #~ fileName = 'C:\Work\Projects\Testing\recordshare\data\ItemsTestData.xls'
  #~ fileName = 'C:\Temp\config123.xls'
  #~ dataArr = ExcelTestUtils.worksheet2array(fileName, "Sheet1")
  #~ puts dataArr[3][2]
  #~ puts dataArr.length.to_s
  #~ puts dataArr[3].length.to_s
  
  
  #~ ArrOfHashes = ExcelTestUtils.data_array2array_of_hashes_1st_column_is_headers(dataArr)
#~ puts "======================="
#~ #print ArrOfHashes[2]["debug"],"\n"
#~ ArrOfHashes.each{|el| puts el["debug"]}
#~ print ArrOfHashes.length

   excelFileName = 'c:\\Temp\\00_test_log23671.xls'
  sheets = ["Config", "Log"]
  array = ["Status", "Action", "Object", "Description"]
   ExcelTestUtils.create_excel_file(excelFileName, sheets)
   #~ exit
   worksheetNumberName = 'Sheet1'
   
   ExcelTestUtils.add_headers2excel_file(excelFileName, worksheetNumberName, array)
   ExcelTestUtils.add_background_color2cells(excelFileName,1)
   array = ["OK", "Action 1", "Object Name 1", "Description 1"]
   ExcelTestUtils.add_array2row(excelFileName, worksheetNumberName, array)
   array = ["NOTOK", "Action 2", "Object Name 2\tSome Other String", "Description 2", 123, "somthing", Time.now]   
   ExcelTestUtils.add_array2row(excelFileName, worksheetNumberName, array)
   ExcelTestUtils.add_new_sheet(excelFileName, "NewOne", 1)
   array = [
                ["Status", "Action", "Object", "Description", "DateTime"],
                ["OK", "get", "default page", "http://seconda:8123/spider", Time.now],
                ["OK", "login", "admin user", "username/password", Time.now],
                ["NOTOK", "book", "deal", "transaction ID", Time.now]
              ]
  ExcelTestUtils.add_two_dimensional_array_to_file(excelFileName, 2, array)
  ExcelTestUtils.change_cell_background_color(excelFileName, 2, 1, "NOTOK", 3)
  ExcelTestUtils.change_row_background_color(excelFileName, 2, 1, "NOTOK", 3)
end
  