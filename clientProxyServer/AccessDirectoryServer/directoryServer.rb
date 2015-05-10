require 'socket'
require './errors'

class DirectoryServer
  attr_accessor :current_Location, :cache, :FileServer                                            
  def initialize(port)                  
    @port = port
    @Disconnect = "KILL_SERVICE"
      
    @DirectoryJoinID = 0
    @DirectoryChatroomNubmer = 0
    
    @error = "ERROR_CODE:"
    
    @cache = 0
    @FileServer = 1
    
    @current_Location
    @current_File
  end
  
  def releventInfo
    if @DirectoryJoinID == 0 and @DirectoryChatroomNubmer == 0
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
      @DirectoryJoinID = line[1]
  
      line = receivedlines[1].split(' ')      
      @DirectoryChatroomNubmer = line[1] 
     
      line = receivedlines[2].split(' ')

      lastLine = receivedlines.length - 1
      responce = line[0].split(':')
      @current_File = responce[1]
      
      location = receivedlines[3].split(':')
      @current_Location = location[1]
      
      if releventInfo
        return @current_File
      else
        errors.currentError = errors.error_InvalidInputToDirectoryServer
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
  
  def findCorrectFile(roomRef,joinID,file,errors)
    s = TCPSocket.open('localhost', @port)
    s.puts "CHATROOM: #{roomRef}\nJOIN_ID: #{joinID}\nDIRECTORY: #{file}\n"
    return receivedData(s,errors)  
  end
  
  def Disconnect(socket)
    socket.puts @Disconnect
  end
  
  def updateFile(roomRef,joinID,file,location)
    s = TCPSocket.open('localhost', @port)
    s.puts "CHATROOM: #{roomRef}\nJOIN_ID: #{joinID}\nUPDATE_FILE: #{file}\nSERVER: #{location}\n" 
    s.puts "KILL_SERVICE\n"
    s.close 
  end 

   
end
