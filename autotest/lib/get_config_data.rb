class GetConfigData
    @@configHash = {}
    def initialize(filename)
      get_config_data(filename)
    end
    
    def get_value(key)
      return @@configHash[key]
    end
    
    def get_url()
      return @@configHash['url']
    end
    
    def get_hash
      return @@configHash
    end
    #@@filename=nil

  def get_config_data(filename)
    file = File.new(filename, "r")
    #configHash={}
    
    while(line = file.gets)
      line.strip!
      next if (line =~ /^#/ or line == '')
      #arr=Array.new
      arr = line.split('=', 2)
      key = arr[0].strip
      value = arr[1].strip
      #puts key + " = " + value
      @@configHash[key]=value
    end
    file.close
    
    #return configHash
  end
  
end

testGetConfigData = false

if testGetConfigData
  filename = 'C:/rba/qa/web/t523/automation/FIT/conf/testconfig.properties'
  a = GetConfigData.new(filename)
  a.get_config_data(filename)
  ha =  a.get_hash
  puts ha
  puts ha['RBA_WEB_URL']
  puts ha['RBA_DB_PORT']
  port = ha['RBA_DB_PORT'].to_i
  puts port
  puts ha['RBA_DB_USERNAME']
end

