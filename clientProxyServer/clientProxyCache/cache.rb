class Cache                                               
  def initialize()                  
    @fileLines = Array.new
    @listOfFiles = availableFiles
  end
  
  def availableFiles
    return Dir["**/*.txt"]
  end
  
  def fileLimit(fileName)
    totalLength = @listOfFiles.length
    if totalLength > 3
      File.delete(@listOfFiles[0])
      @listOfFiles[0] = @listOfFiles[1]
      @listOfFiles[1] = @listOfFiles[2]
      @listOfFiles[2] = fileName
    else
      @listOfFiles[totalLength] = fileName
    end
  end
  
  def download(desiredFile)
    @fileLines = Array.new
    if File.file?("clientProxyCache/#{desiredFile}.txt")
      count = 0
      f = File.open("clientProxyCache/#{desiredFile}.txt", "r")
      f.each_line do |line|
        @fileLines[count] = line
        count += 1
      end      
      f.close 
      return @fileLines
    else
      return false       
    end
  end
  
    def uploadEntireDocument(uploadContent,fileName)
    File.open("clientProxyCache/#{fileName}.txt", 'w') do |f|
      numOfLines = uploadContent.length
      count = 0 
      while numOfLines > count
        f << "#{uploadContent[count]}"
        count += 1
      end
    end
  end
  
end
