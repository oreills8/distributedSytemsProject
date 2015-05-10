require './errors'
require './directory'

class Client                                                
  attr_accessor :connection,  :ClientProxyJoinID, :ChatroomNumber, :error,
  :updatingFile
  def initialize(setJoinID, setConnection)
   @joinID = setJoinID                 
   @connection = setConnection
   
   @ClientProxyJoinID = 0
   @ChatroomNumber = 0 
   
   @error = Error.new()
   @directory = Directory.new
   
   @updatingFile = false
   @fileToBeUpdated
  end
  
 def clientDisconnect()
    @ClientProxyJoinID = 0
    @ChatroomNumber = 0   
    @connection.close 
  end
  
  def clientRespondMessage(text,iP,port)
      @connection.puts "HELO #{text}\nIP:#{iP}\nPort:#{port}\nStudentID:10327713\n"    
  end
  
  def releventInfo
    if @ClientProxyJoinID == 0 and @ChatroomNumber == 0
      return false
    else
      return true
    end
  end
  
  def returnDirectory(inputFile)
    if releventInfo
      file = @directory.returnFile(inputFile)
      if file
        @connection.puts "CHATROOM: #{@ChatroomNubmer}\nJOIN_ID: #{@ClientProxyJoinID}\nDIRECTORY:#{file}\nSERVER:#{@directory.current_Location}\n"
      else
        @error.currentError = @error.error_FileNotInDirectory
        @error.ErrorMessage(@connection)
      end
    else
      @error.currentError = @error.error_NotAllReleventInfoReceivedByDirectoryServer
      @error.ErrorMessage(@connection)  
    end  
  end 
  
  def updateFile(line)
    @updatingFile = true
    @fileToBeUpdated = line
  end
  
  def updateFileLocation(line)
    @directory.updateFileLocationDirectory(@fileToBeUpdated,line)
  end
  
end
