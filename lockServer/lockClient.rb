require 'socket' 
require './errors'

class Client                                                
  attr_accessor :connection,  :ClientProxyJoinID, :ChatroomNumber, :error, :file, :waiting
  def initialize(setJoinID, setConnection)
   @joinID = setJoinID                 
   @connection = setConnection
   
   @ClientProxyJoinID = 0
   @ChatroomNumber = 0 
   
   @error = Error.new()
   
   @file = "default"
   @waiting = true
  end
  
 def clientDisconnect()
    while (@waiting)
      sleep(5)
    end
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
  
end
