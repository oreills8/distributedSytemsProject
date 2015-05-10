
class Error                                               
  attr_accessor :currentError, :error_CannotEnterChatroom, :error_AllRelevantInforNotSent, :error_CannotSendMessage,
  :error_InvalidOperation, :error_FileDoesntExist, :error_notAllReleventInfo, :error_InvalidInputToFileServer,
  :error_FileDoesntExistInFileServer, :error_InvalidResponceFromFileServer,
  :error_InvalidInputToLockServer, :error_NotAllReleventInfoReceivedByLockServer,
  :error_FileLocked, :error_FileNotLocked, :error_InvalidInputToDirectoryServer, 
  :error_NotAllReleventInfoReceivedByDirectoryServer,:error_FileNotInDirectory
  def initialize()                  
   
   @error_CannotEnterChatroom = '1'
   @error_AllRelevantInforNotSent = '2'
   @error_CannotSendMessage = '3'
   @error_InvalidOperation = '4'
   @error_FileDoesntExist = '5'
   @error_notAllReleventInfo = '6'
   @error_InvalidInputToFileServer = '7'
   @error_FileDoesntExistInFileServer = '8'
   @error_InvalidResponceFromFileServer = '9'
   
   @error_InvalidInputToLockServer = '10'
   @error_NotAllReleventInfoReceivedByLockServer = '11'
   @error_FileLocked = '12'
   @error_FileNotLocked = '13' 
   
   @error_InvalidInputToDirectoryServer = '14'
   @error_NotAllReleventInfoReceivedByDirectoryServer = '15'
   @error_FileNotInDirectory = '16'
   
   @currentError = 0 
   
  end

  def ErrorMessage(connection)
    case @currentError
    when 0
      line = "Error - no error"
    when @error_CannotEnterChatroom
      line = "client cannot enter chatroom"
    when @error_AllRelevantInforNotSent
      line = "You did not send all relevant information to enter this Chatroom"
    when @error_CannotSendMessage
      line = "You did not send all relevant information to send this message"
    when @error_InvalidOperation
      line = "Invalid Operation"
    when @error_FileDoesntExist
      line = "The File you have Requested Does not Exist"
    when @error_notAllReleventInfo
      line = "Not all Relevent Information about Client was Received"
    when @error_InvalidInputToFileServer
      line = "The Client Proxy Server is not sending correct data to File Server"
    when @error_FileDoesntExistInFileServer
      line = "The requested file does not exist."
    when @error_InvalidResponceFromFileServer
      line = "Invalid Responce from file server. File Server not Behaving as expected"
    when @error_InvalidInputToLockServer
      line = "Invalid Responce from lock server. File Server not Behaving as expected"
    when @error_NotAllReleventInfoReceivedByLockServer
      line = "All Relevent Info has not been sent to lock server."
    when @error_FileLocked
      line = "Cannot access this file as it is currently locked."
    when @error_FileNotLocked
      line = "Cannot release this file as it is not locked."
    when @error_InvalidInputToDirectoryServer
      line = "The Client Proxy Server is not sending correct data to Directory Server"
    when @error_NotAllReleventInfoReceivedByDirectoryServer
      line = "All Relevent Info has not been sent to directory server."
    when @error_FileNotInDirectory
      line = "The sent file is not in the directory"
    else
      line = "Unknown Error"
    end
     connection.puts "ERROR_CODE: #{@currentError}. ERROR_DESCRIPTION: #{line}"
  end
   
end
