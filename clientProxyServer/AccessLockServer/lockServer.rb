require 'socket'
require './errors'

class LockServer                                               
  def initialize(port)
    @port = port
    
    @returnFiles = "AVAILABLE_FILES"
    @lock = "LOCK_SUCESSFUL"
    @Unlock = "UNLOCK_SUCESSFUL"
    @Disconnect = "KILL_SERVICE"
   
    @LockServerJoinID = 0
    @LockServerChatroomNubmer = 0
    
    @error = "ERROR_CODE:"
  end
  
  def releventInfo
    if @LockServerJoinID == 0 and @LockServerChatroomNubmer == 0
      return false
    else
      return true
    end
  end
  
  def returnAvailableFiles(roomRef, joinID, errors)
    s = TCPSocket.open('localhost', @port)
    s.puts "CHATROOM: #{roomRef}\nJOIN_ID: #{joinID}\nAVAILABLE_FILES\n"
    return receivedData(s,errors) 
  end
  
  def lockedFile(roomRef, joinID, file, errors)
    s = TCPSocket.open('localhost', @port)
    s.puts "CHATROOM: #{roomRef}\nJOIN_ID: #{joinID}\nLOCK: #{file}\n"
    if receivedData(s,errors) == @lock
      return true
    else
      return "ERROR"
    end      
  end
  
  def unlockFile(roomRef, joinID,file, errors)
    s = TCPSocket.open('localhost', @port)
    s.puts "CHATROOM: #{roomRef}\nJOIN_ID: #{joinID}\nUNLOCK: #{file}\n"
    if receivedData(s,errors) == @Unlock
      return true
    else
      return "ERROR"
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
  
  def Disconnect(socket)
    socket.puts @Disconnect
  end 
  
  def messageReceived(receivedlines,errors)
    if receivedlines[0].include? @error
      line = receivedlines[0].split(' ')
      line[1].slice! '.'
      errors.currentError = line[1]
      return "ERROR"
    else      
      lastLine = receivedlines.length - 1
      
      responce = receivedlines[1..lastLine]
      return responce    
    end                    
  end 
  
end
