
class Server                                                
  attr_accessor :enteringClients,  :ServerIP, :ServerPort, :socket, :IsOpen, :ClientCount
  def initialize(iPAddress)
    @enteringClients = Queue.new 
    @ServerPort = 2800

    @ServerIP = iPAddress
    @socket = TCPServer.open(@ServerPort)
    @IsOpen = true                              #Isopen is a boolean for if the socket is still open or not
    @ClientCount = 0
     
    @Disconnect = "KILL_SERVICE"
    @RespondMessage = "HELO"
    @ClientIDinfo = "CHATROOM:" 
    @ClientChatroomInfo = "JOIN_ID:"
    @Directory = 'DIRECTORY:'
    @update = 'UPDATE_FILE:'
    
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
    when @ClientIDinfo
      client1.ClientProxyJoinID = body
    when @ClientChatroomInfo
      client1.ChatroomNumber = body
    when @Directory
      client1.returnDirectory(body)
    when @update
      client1.updateFile(body)
    else
      if client1.updatingFile
        client1.updateFileLocation(body)
      else
        client1.error.currentError = client1.error.error_InvalidInputToDirectoryServer
        client1.error.ErrorMessage(client1.connection)
      end
    end                    
  end
  
end
