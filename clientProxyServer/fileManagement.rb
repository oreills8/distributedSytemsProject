require 'socket'
require './clientProxyCache/cacheAccess'
require './AccessFileServer/fileServer'
require './AccessLockServer/lockServer'
require './AccessDirectoryServer/directoryServer'

class FileDirectory
  attr_accessor :connection, :sectionStart, :sectionEnd                                             
  def initialize(fileport, lockport, directoryport)
    
    @sectionStart = "default"
    @sectionEnd = "default"
    
    @EntireDocument = "ENTIRE_DOCUMENT"
    
    @cache = CacheAccess.new()
    @fileServer = FileServer.new(fileport)
    @lockServer = LockServer.new(lockport)
    @directoryServer = DirectoryServer.new(directoryport)
  end

  
  
  def upload(roomRef, joinID, file, section, uploadData, client, errors)
      file = @directoryServer.findCorrectFile(roomRef,joinID,file,errors)
      fileLocked = @lockServer.lockedFile(roomRef,joinID,file,errors)
      if fileLocked
        receivedData = @fileServer.uploadRequest(roomRef,joinID,file,section,uploadData,errors)
        if receivedData
          @cache.cacheFile(receivedData,file)    
        end
        fileUnlocked = @lockServer.unlockFile(roomRef,joinID,file,errors)
        if !fileUnlocked
          receivedData = fileUnLocked
        end
      else
        receivedData = fileLocked
      end
      return receivedData
  end
  

  def download(file,section,client,roomRef,joinID, errors)
    file = @directoryServer.findCorrectFile(roomRef,joinID,file,errors)
    if @directoryServer.current_Location == @directoryServer.cache
      receivedData = @cache.downloadFile(file,section)
      return receivedData
    else
      count = 0
      receivedData = @fileServer.downloadRequest(roomRef,joinID,file,errors)
      if receivedData != "ERROR"
        @cache.cacheFile(receivedData,file)
        @directoryServer.updateFile(roomRef,joinID,file,@directoryServer.cache)
        if section != @EntireDocument
          receivedData = downloadFileSection(receivedData)
        end
      end
      return receivedData
    end 
  end
  
   def downloadFileSection(downloadledFile)
      extractingThisSection = false
      numOfLines = downloadledFile.length
      count = 0
      returnCount = 0
      returnValue = Array.new 
      while numOfLines > count
        if downloadledFile[count].include? @sectionStart
          extractingThisSection = true
        elsif downloadledFile[count].include? @sectionEnd
          extractingThisSection = false
          count = numOfLines
        end
        if extractingThisSection == true
          returnValue[returnCount] =  downloadledFile[count]
          puts returnValue[returnCount]
          returnCount += 1
        end
         count += 1
      end
    return returnValue
  end

  def availableFiles(roomRef, joinID, errors)
    receivedData = @lockServer.returnAvailableFiles(roomRef,joinID,errors)
    return receivedData
  end
  
end
