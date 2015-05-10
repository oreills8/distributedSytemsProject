require './FileAccess'

class Client                                                
  attr_accessor :connection, :error_InvalidOperation, :uploadingFile, :ClientProxyJoinID,
    :ChatroomNubmer
  def initialize(setJoinID, setConnection)                  
   @connection = setConnection 
   @ClientIP = 0
   @ClientPort = 0
   @InternalJoinID = setJoinID
   @ClientProxyJoinID = 0
   @ChatroomNubmer = 0
   
   @error_InvalidOperation = 7
   @error_FileDoesntExist = 8
   @error_notAllReleventInfo = 6
   
   @accessfiles = FileAccess.new()
   @uploadingFile = false
   @uploadContent = Array.new
   @uploadContentCount = 0
   @uploadFileName = "default"
   @uploadFileSection = "default"
  end
  
  def releventInfo
    if @ClientProxyJoinID == 0 and @ChatroomNubmer == 0
      return false
    else
      return true
    end
  end
  
  def returnAvailableFiles
    if releventInfo
      files = @accessfiles.availableFiles()
      if !files
        ErrorMessage(@error_FileDoesntExist)
      else
        @connection.puts "CHATROOM: #{@ChatroomNubmer}\nJOIN_ID: #{@ClientProxyJoinID}\nAVAILABLE_FILES:\n"
        numOfLines = files.length
        count = 0 
        while numOfLines > count
          @connection.puts "#{files[count]}"
          count = count + 1
        end
      end
    else
      ErrorMessage(@error_notAllReleventInfo)  
    end

  end
  
  def downloadFile(line)
    line = line.split(',')
    fileName = line[0]
    if releventInfo
      downloadledFile = @accessfiles.download(fileName)
      if !downloadledFile
        ErrorMessage(@error_FileDoesntExist)
      else
        @connection.puts "CHATROOM: #{@ChatroomNubmer}\nJOIN_ID: #{@ClientProxyJoinID}\nDOWNLOADED_FILE:\n"
        @connection.puts downloadledFile
      end
    else
      ErrorMessage(@error_notAllReleventInfo)  
    end
  end
  
  def uploadFile(fileContent)
    @uploadContent[@uploadContentCount] = fileContent
    @uploadContentCount = @uploadContentCount + 1
  end
  
  def uploadFileName(line)
    line = line.split(',')
    file = line[0].split(' ')
    @uploadFileName = file[1]
    section = line[1].split(' ')      
    if section[1] != "ENTIRE_DOCUMENT"
      @uploadFileSection = section[1]
    else
      @uploadFileSection = "ENTIRE_DOCUMENT"
    end
  end
  
  def finsihedUploadingFile()
    if releventInfo
      uploadedFile = @accessfiles.upload(@uploadContent,@uploadFileName,@uploadFileSection)
      if !uploadedFile
        ErrorMessage(@error_FileDoesntExist)
      else
        @connection.puts "CHATROOM: #{@ChatroomNubmer}\nJOIN_ID: #{@ClientProxyJoinID}\nUPLOADED_FILE:\n"
        numOfLines = uploadedFile.length
        count = 0 
        while numOfLines > count
          @connection.puts "#{uploadedFile[count]}"
          count = count + 1
        end
      end
      @uploadContentCount = 0
      @uploadContent = Array.new
    else
      ErrorMessage(@error_notAllReleventInfo)  
    end
  end
  
  def ErrorMessage(error)
    case error
    when @error_InvalidOperation
      line = "Invalid Operation"
    when @error_FileDoesntExist
      line = "The File you have Requested Does not Exist"
    when @error_notAllReleventInfo
      line = "Not all Relevent Information about Client was Received"
    else
      line = "Unknown Error"
    end
     @connection.puts "ERROR_CODE: #{error}. ERROR_DESCRIPTION: #{line}"
  end
  
  def clientDisconnect()
      @ClientProxyJoinID = 0
      @ChatroomNubmer = 0   
      @connection.close 
  end
  
  def clientRespondMessage(text,iP,port)
      @connection.puts "HELO #{text}\nIP:#{iP}\nPort:#{port}\nStudentID:10327713\n"    
  end
  
end
