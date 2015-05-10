
class Error                                               
  attr_accessor :currentError, :error_InvalidInputToFileServer,
  :error_FileDoesntExistInFileServer, :error_InvalidResponceFromFileServer,
  :error_InvalidInputToLockServer, :error_NotAllReleventInfoReceivedByLockServer,
  :error_FileLocked, :error_FileNotLocked
  def initialize()                  
   
   @error_InvalidInputToFileServer = '7'
   @error_FileDoesntExistInFileServer = '8'
   @error_InvalidResponceFromFileServer = '9'
   
   @error_InvalidInputToLockServer = '10'
   @error_NotAllReleventInfoReceivedByLockServer = '11'
   @error_FileLocked = '12'
   @error_FileNotLocked = '13' 
   
   @currentError = 0 
   
  end

  def ErrorMessage(connection)
    case @currentError
    when 0
      line = "Error - no error"
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
    else
      line = "Unknown Error"
    end
     connection.puts "ERROR_CODE: #{@currentError}. ERROR_DESCRIPTION: #{line}"
  end
   
end
