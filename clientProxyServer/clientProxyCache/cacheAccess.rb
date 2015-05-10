
require './clientProxyCache/cache'
class CacheAccess                                                                                            
  def initialize()                  
   @onlyExtractSection = false
   @extractingThisSection = true
   @cache = Cache.new()
  end
  
    def ifFileInCache(desiredFile)
    if File.file?("clientProxyCache/#{desiredFile}.txt")
      return true
    else
      return false       
    end
  end
  
  def cacheFile(uploadContent,fileName)
    @cache.fileLimit(fileName)
    @cache.uploadEntireDocument(uploadContent,fileName)
  end
  
  def returnAvailableFiles
    return @cache.availableFiles()
  end
  
  def downloadFile(fileName,section)
    downloadedFile = @cache.download(fileName)
    returnValue = Array.new
    numOfLines = downloadedFile.length
    count = 0
    returnCount = 0
    if section != "ENTIRE_DOCUMENT"
      @onlyExtractSection = true
      @extractingThisSection = false
      sections = section.split(" until ")
      sectionStart = sections[0]
      sectionEnd = sections[1]
      while numOfLines > count
        if @onlyExtractSection == true
          if downloadedFile[count].include? sectionStart
            @extractingThisSection = true
          elsif downloadedFile[count].include? sectionEnd
            @extractingThisSection = false
            count = numOfLines
          end
        end
        if @extractingThisSection == true
          returnValue[returnCount] = downloadedFile[count]
          returnCount += 1
        end
        count += 1
      end
    else
      returnValue = downloadedFile
    end
    return returnValue
  end
 
  
end
