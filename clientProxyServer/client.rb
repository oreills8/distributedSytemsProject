 
require 'socket'
require './errors'

class Client                                                
  attr_accessor :connection, :Name, :chatroomConnected, :RoomRef, :leavingChatroom, :disconnecting, 
  :uploading, :joiningChatroom, :joinID, :RoomRef
  def initialize(setJoinID, setConnection)                  
   @connection = setConnection 
   @ClientIP = 0
   @ClientPort = 0
   @Name = "Default"
   @chatroomConnected = false
   @leavingChatroom = false
   @disconnecting = false
   @uploading = false
   @joiningChatroom = false
   @joinID = setJoinID
   @RoomRef = 0
   @chatroomName = "Default"
   
   @errors = Error.new()
   
   @returnFiles = "AVAILABLE_FILES:"
   @Upload = "UPLOADED_FILE:"
   @Download = "DOWNLOADED_FILE:"
   @EntireDocument = "ENTIRE_DOCUMENT"
   
   @uploadData = Array.new
   @uploadDataCount = 0
   @fileName = "default"
   @sectionName = "default"
  end
  
  def printDetailsJoining(serverIP,serverPort)
    return "JOIN_CHATROOM: #@chatroomName\nSERVER_IP: #{serverIP}\nPORT: #{serverPort}\nROOM_REF: #@RoomRef\nJOIN_ID: #@joinID\n"
  end
  
  def printDetailsLeaving()
    return "LEFT_CHATROOM: #@RoomRef\nJOIN_ID: #@joinID\n"
  end
  
  def releventInfo()
    if @ClientIP != 0 and @ClientPort != 0 and @joinID != 0
      return true
    else
      return false
    end
  end
  
  def returnResponce(command,response)  
   if  response == "ERROR"
     @errors.ErrorMessage(@connection)
   else
     @connection.puts command
     @connection.puts response
   end
  end
             
   def downloadingFile(line, fileManagement)
    fullLine = line
    line = line.split(',')
    file = line[0].split(':')
    fileName = file[1]
    if fullLine.include? "SECTION:"
      section = line[1].split(':')
      sectionName = section[1]
      if !sectionName.include? " until "
        sectionName = "#{sectionName} until THE_END_OF_THE_FILE"
      end
      sections = sectionName.split(" until ")
      fileManagement.sectionStart = sections[0]
      fileManagement.sectionEnd = sections[1]
    else
      sectionName = @EntireDocument
    end
    response = fileManagement.download(fileName,sectionName,@self,@RoomRef,@joinID,@errors) 
    returnResponce(@Download,response)
   end     
   
   def uploadingFile(line, fileManagement)
     line = line.split(' ') 
     case line[0]
     when "UPLOAD:"
      if line.join(' ').include? "SECTION:"
        line = line.join(' ').split(',')
        file = line[0].split(':')
        @fileName = file[2]
        section = line[1].split(':')
        @sectionName = section[1]
      else
        file = line[1].split(':')
        @fileName = file[1]
        @sectionName = @EntireDocument
      end 
     when "FINISHED_UPLOADING"
        response = fileManagement.upload(@roomRef,@joinID,@fileName,@sectionName,@uploadData.join("\n"),@self,@errors)
        returnResponce(@Upload,response)
        @uploadData = Array.new
        @uploadDataCount = 0
     else
       @uploadData[@uploadDataCount] = line.join(' ')
       @uploadDataCount = @uploadDataCount + 1 
     end  
   end 
   
   def gettingAvailableFiles(fileManagement)
     response = fileManagement.availableFiles(@roomRef,@joinID,@errors)
     returnResponce(@returnFiles,response)
   end 
  
  def canClientEnter(line,server1)
    headers,body = line.split      # Split response at first blank line into headers and body
    case headers
    when "JOIN_CHATROOM:"
      @chatroomName = body
      @RoomRef = server1.returnRoomRef(@chatroomName,self)
    when "CLIENT_IP:"
      @ClientIP = body
    when "PORT:"
      @ClientPort = body
    when "CLIENT_NAME:"
      @Name = body    
      if releventInfo() == true
        @connection.puts printDetailsJoining(server1.ServerIP,server1.ServerPort)
        @chatroomConnected = true
      else
      @errors.ErrorMessage(@errors.error_AllRelevantInforNotSent, @connection) 
      end
    else
      @errors.ErrorMessage(@errors.error_AllRelevantInforNotSent, @connection)            
    end      
  end
  
  def clientDisconnect(line)
    headers,body = line.split       # Split response at first blank line into headers and body 
    if headers == "CLIENT_NAME:"      
      @connection.close
    end   
  end
   
end
