require './AccessFileServer/FileServerAccess'
require './errors'

class LockManagement
  attr_accessor :clientsWishingToLock, :clientsWishingToUnlock, :clientsWishingToDisconnect                                             
  def initialize()
    @ServerFilePort = 2600                  
   
    @availableFiles = Array.new
    @lockedFiles = Array.new
    @waitingOnFile = Hash.new
   
    @fileFunctions = FileServerAccess.new(@ServerFilePort)
    
    @clientsWishingToLock = Array.new
    @clientsWishingToUnlock = Array.new
    @clientsWishingToDisconnect = Array.new
        
  end
  
  def checkingForFiles()
     if @clientsWishingToLock.length > 0
      lock(@clientsWishingToLock.pop)       
     elsif @clientsWishingToUnlock.length > 0
      unlock(@clientsWishingToUnlock.pop) 
    end
  end
  
   def updateAvailableFiles(client)
    answer = @fileFunctions.availableFiles(client,client.error)
    if answer == "ERROR"
      error.ErrorMessage(client.connection)
      @availableFiles = 0
    else
      count = answer.length - 1
      for i in 0..count
        answer[i].slice! '.txt'
      end
      @availableFiles = answer   
    end
  end
  
  def lock(client)
    file = client.file
    if client.releventInfo
      updateAvailableFiles(client)
      if @availableFiles != 0
        if @availableFiles.include? "#{file}\n" 
          if @lockedFiles.include? file
            @waitingOnFile[file] = client
          else
            @lockedFiles.push(file)
            client.waiting = false
            client.connection.puts "LOCK_SUCESSFUL\n" 
          end
        else
         client.error.currentError =client.error.error_FileDoesntExistInFileServer
         client.error.ErrorMessage(client.connection)
        end
      end    
    else
       client.error.currentError = client.error.error_NotAllReleventInfoReceivedByLockServer
       client.error.ErrorMessage(client.connection)
    end
  end   
  
  def unlock(client)
    file = client.file
    if client.releventInfo
        if @lockedFiles.include? file
          if @waitingOnFile.has_key?(file)
            tempClient = @waitingOnFile[file]
            tempClient.waiting = false
            tempClient.connection.puts "LOCK_SUCESSFUL AFTER WAITING\n"
            @waitingOnFile.delete(file)
          end     
          @lockedFiles.delete(file)
          client.waiting = false
          client.connection.puts "UNLOCK_SUCESSFUL\n"
        else
          client.error.currentError = client.error.error_FileNotLocked
          client.error.ErrorMessage(client.connection)
        end  
    else
       client.error.currentError = client.error.error_NotAllReleventInfoReceivedByLockServer
       client.error.ErrorMessage(client.connection)
    end
  end
  
  
  def returnAvailableFiles(client)
    if client.releventInfo
      updateAvailableFiles(client)
      if @availableFiles != 0
        client.connection.puts "AVAILABLE_FILES:"
        count = @availableFiles.length - 1
        for i in 0..count
          client.connection.puts @availableFiles[i]
        end
        client.connection.puts "LOCKED_FILES:"
        count = @lockedFiles.length - 1
        for i in 0..count
          client.connection.puts @lockedFiles[i]
        end
      end  
    else
       client.error.currentError = client.error.error_NotAllReleventInfoReceivedByLockServer
       client.error.ErrorMessage(client.connection)
    end     
  end

end
