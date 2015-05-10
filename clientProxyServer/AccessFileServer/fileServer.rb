require 'socket'
require './errors'

class FileServer                                               
  def initialize(port)                  
    @port = port
    @Disconnect = "KILL_SERVICE"
      
    @ClientProxyJoinID = 0
    @ChatroomNubmer = 0
    
    @error = "ERROR_CODE:"
  end
  
  def releventInfo
    if @ClientProxyJoinID == 0 and @ChatroomNubmer == 0
      return false
    else
      return true
    end
  end
  
  def messageReceived(receivedlines,errors)
    if receivedlines[0].include? @error
      line = receivedlines[0].split(' ')
      line[1].slice! '.'
      errors.currentError = line[1]
      return "ERROR"
    else
      line = receivedlines[0].split(' ')      
      @ClientProxyJoinID = line[1]
  
      line = receivedlines[1].split(' ')      
      @ChatroomNubmer = line[1] 
     
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
    
  def receivedData(socket,errors)
    receivedData = Array.new
    count = 0
    Disconnect(socket) 
    while line = socket.gets   # Read lines from the socket
      puts line
      receivedData[count] = line
      count = count + 1     
    end
    socket.close               # Close the socket when done
    return messageReceived(receivedData,errors)
  end
  
  def uploadRequest(roomRef,joinID,file,section,uploadData,errors)
    s = TCPSocket.open('localhost', @port)
    s.puts "CHATROOM: #{roomRef}\nJOIN_ID: #{joinID}\nFILE_NAME: #{file},SECTION: #{section}\n"
    s.puts "UPLOAD: #{uploadData}\nFINISHED_UPLOADING\n"
    return receivedData(s,errors)  
  end
  
  def downloadRequest(roomRef,joinID,file,errors)
    s = TCPSocket.open('localhost', @port)
    s.puts "CHATROOM: #{roomRef}\nJOIN_ID: #{joinID}\nDOWNLOAD: #{file}\n"
    return receivedData(s,errors) 
  end
  
  def availableFilesRequest(roomRef,joinID,file,errors)
    s = TCPSocket.open('localhost', @port)
    s.puts "CHATROOM: #{roomRef}\nJOIN_ID: #{joinID}\nAVAILABLE_FILES\n"
    return receivedData(s,errors) 
  end
  
  def Disconnect(socket)
    socket.puts @Disconnect
  end 

   
end
