require 'logger'

class TestLogger
  @@startTime = Time.now
  @@logFileName = nil
  @@logFile = nil
  #~ def logFile
    #~ return @@logFile
  #~ end
  
  def initialize(logDirectory, suffixName= "")
    @@logFileName = create_log_file(logDirectory, suffixName)
    #puts @@logFileName
     @@logFile = File.new(@@logFileName, "w+")
    #@@logFile = Logger.new(@@logFileName, "w+")


    #@@logFile << @@startTime 
    #@@logFile.close
    #return(logFile)
  end
  
  def create_log_file(logDirectory, suffixName)
	if suffixName != ""
		logFileName = Time.now.strftime("#{logDirectory}/#{File.basename($0)}_#{suffixName}_Log %b %d %Y %H %M %S.txt")
	else
		logFileName = Time.now.strftime("#{logDirectory}/#{File.basename($0)}_Log %b %d %Y %H %M %S.txt")
	end
    return(logFileName)
  end
  
  def get_log_file_name
    return(@@logFileName)
  end
  
  def get_log_file_obj
    return @@logFile
  end
  
  
  def write2log(status, action, object, details)
    @@logFile << "#{status}\t#{action}\t#{object}\t#{details}\r\n"
  #   if (status == '0') then
  #    @@logFile << "#{status}\t#{action}\t#{object}\r\n"
  #   else
  #    @@logFile << "#{status}\t#{action}\t#{object}\t#{details}\r\n"
  #   end
  end

  # def write2log(status, action, object)
  #   info = Array.new
  #   info = status, action, object
  #   # info = "#{status}\t\t#{action}\t#{object}\t#{details}\r\n"
  #   @@logFile << info
  # end

  
  # adds header to a log file
  def add_header2log(config)
    #puts config
    config.each{|key, value|
        @@logFile << "#{key}\t#{value}\r\n"
    }
    #~ @@logFile << "URL:\t#{config['url'])}\r\n"
    #~ @@logFile << "Username:\t#{config('username')}\r\n" 
    #~ @@logFile << "Password:\t#{config('password')}\r\n"
    @@logFile << "Start Time:\t" + @@startTime.strftime("%b-%d-%Y %H:%M:%S") + "\r\n"
  end
  
  def test_time2log()
    #stops timer
    endTime = Time.now

    #Calculates total time elapsed.
    totalTime = endTime - @@startTime

    #Print total time elapsed to screen and log file.
    @@logFile << "Finish Time:\t#{endTime.strftime("%b-%d-%Y %H:%M:%S")}\r\n"
    @@logFile << "Total Elapsed time:\t#{totalTime} seconds\r\n"
  end
end
