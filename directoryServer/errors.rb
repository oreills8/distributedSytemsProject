class Error                                               
  attr_accessor :currentError, :error_InvalidInputToDirectoryServer, 
  :error_NotAllReleventInfoReceivedByDirectoryServer,:error_FileNotInDirectory
  def initialize()                  
   
   @error_InvalidInputToDirectoryServer = '14'
   @error_NotAllReleventInfoReceivedByDirectoryServer = '15'
   @error_FileNotInDirectory = '16'
   
   @currentError = 0 
   
  end

  def ErrorMessage(connection)
    case @currentError
    when 0
      line = "Error - no error"
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
