require 'socket' 

class FileServerAccess                                               
  def initialize(port)                  
    @fileServerPort = port
    @Disconnect = "KILL_SERVICE"
    
    @FileServerJoinID = 0
    @FileServerChatroomNumber = 0
    
    @error = "ERROR_CODE:"
  end
  
  def releventInfo
    if @FileServerJoinID == 0 and @FileServerChatroomNumber == 0
      return false
    else
      return true
    end
  end
  
  def availableFiles(client,error)
      count = 0
      receivedData = Array.new
      s = TCPSocket.open('localhost', @fileServerPort)
      s.puts "CHATROOM: #{client.ChatroomNumber}\nJOIN_ID: #{client.ClientProxyJoinID}\nAVAILABLE_FILES\n"
      Disconnect(s)
        
      while line = s.gets   # Read lines from the socket
        puts line
        receivedData[count] = line
        count = count + 1     
      end
      s.close               # Close the socket when done
      return messageReceived(receivedData,error)
  end
  
   def messageReceived(receivedlines,errors)
    if receivedlines[0].include? @error
      line = receivedlines[0].split(' ')
      line[1].slice! '.'
      errors.currentError = line[1]
      return "ERROR"
    else
      line = receivedlines[0].split(' ')      
      @FileServerJoinID = line[1]
  
      line = receivedlines[1].split(' ')      
      @FileServerChatroomNumber = line[1] 
     
      line = receivedlines[2].split(' ')      
      
      lastLine = receivedlines.length - 1
      
      responce = receivedlines[3..lastLine]
      if releventInfo
        return responce
      else
        errors.currentError = errors.error_InvalidResponceFromFileServer
        return "ERROR"
      end     
    end
                    
  end
  
  def Disconnect(socket)
    socket.puts @Disconnect
  end 
 
end
