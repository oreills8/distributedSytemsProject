require './lockManagement'

class Server                                                
  attr_accessor :enteringClients,  :ServerIP, :ServerPort, :socket, :IsOpen, :ClientCount, :LockFunctions
  def initialize(iPAddress)
    @enteringClients = Queue.new 
    @ServerPort = 2700

    @ServerIP = iPAddress
    @socket = TCPServer.open(@ServerPort)
    @IsOpen = true                              #Isopen is a boolean for if the socket is still open or not
    @ClientCount = 0
     
    @returnFiles = "AVAILABLE_FILES"
    @lock = "LOCK:"
    @Unlock = "UNLOCK:"
    @Disconnect = "KILL_SERVICE"
    @RespondMessage = "HELO"
    @ClientIDinfo = "CHATROOM:" 
    @ClientChatroomInfo = "JOIN_ID:"
    
    @LockFunctions = LockManagement.new()
  end
  
  def messageReceived(line, client1)
    splitLine = line.split(' ')      
    lastElement = splitLine.length - 1
    body = splitLine[1..lastElement].join(' ') 
    case splitLine[0]
    when @RespondMessage
      client1.clientRespondMessage(body,@ServerIP,@ServerPort)
    when @Disconnect
      client1.clientDisconnect()
    when @returnFiles
      @LockFunctions.returnAvailableFiles(client1)
    when @lock
      client1.file = body
      @LockFunctions.clientsWishingToLock.push(client1)
    when @Unlock
      client1.file = body
      @LockFunctions.clientsWishingToUnlock.push(client1)  
    when @ClientIDinfo
      client1.ClientProxyJoinID = body
    when @ClientChatroomInfo
      client1.ChatroomNumber = body
    else
      client1.error.currentError = client1.error.error_InvalidInputToLockServer
      client1.error.ErrorMessage(client1.connection) 
    end                    
  end  
end
