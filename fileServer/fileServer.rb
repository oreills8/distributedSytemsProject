
class Server                                                
  attr_accessor :enteringClients,  :ServerIP, :ServerPort, :socket, :IsOpen, :ClientCount
  def initialize(iPAddress)
    @enteringClients = Queue.new 
    @ServerPort = 2600
    @ServerIP = iPAddress
    @socket = TCPServer.open(@ServerPort)
    @IsOpen = true                              #Isopen is a boolean for if the socket is still open or not
    @ClientCount = 0 
    @returnFiles = "AVAILABLE_FILES"
    @Upload = "UPLOAD:"
    @Download = "DOWNLOAD:"
    @Disconnect = "KILL_SERVICE"
    @RespondMessage = "HELO"
    @FinishedUploading = "FINISHED_UPLOADING" 
    @ClientIDinfo = "CHATROOM:" 
    @ClientChatroomInfo = "JOIN_ID:"
    @uploadFileName = "FILE_NAME:"
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
      client1.returnAvailableFiles
    when @Download
      client1.downloadFile(body)
    when @uploadFileName
      client1.uploadFileName(line)
    when @FinishedUploading
      client1.finsihedUploadingFile()
      client1.uploadingFile = false
    when @Upload
      client1.uploadFile(body)
      client1.uploadingFile = true
    when @ClientIDinfo
      client1.ClientProxyJoinID = body
    when @ClientChatroomInfo
      client1.ChatroomNubmer = body
    else
      if client1.uploadingFile
        client1.uploadFile(line)
      else
        client1.ErrorMessage(client1.error_InvalidOperation) 
      end  
    end                    
  end
end
