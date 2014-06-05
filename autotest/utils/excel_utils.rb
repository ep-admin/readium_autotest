require 'rubyXL'

class ExcelUtils
	def self.worksheet2array(excelDataFileName, worksheetNumber)
		workbook = RubyXL::Parser.parse(excelDataFileName)
		dataArray = workbook.worksheets[worksheetNumber].extract_data
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
end  # End of class ExcelUtils
