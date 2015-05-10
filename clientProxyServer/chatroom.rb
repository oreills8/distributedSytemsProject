
class Chatroom                                                
  attr_accessor :RoomRef, :jointClients, :leftClients, :name
  def initialize(name, chatroomCount)                  
   @name = name 
   @RoomRef = chatroomCount 
   @jointClients = Array.new
   @leftClients = Array.new
   @currentMessage
  end
  def forwardMessage(line, client1) 
    splitLine = line.split(' ')       # Split response at first blank line into headers and body
    case splitLine[0]
    when "CHAT:"
      @currentMessage = Message.new()
      @currentMessage.RoomRef = splitLine[1]
    when "JOIN_ID:"
      @currentMessage.JoinID = splitLine[1]
    when "CLIENT_NAME:"
      @currentMessage.clientName = splitLine[1]
    when "MESSAGE:"
      lastElement = splitLine.length - 1
      @currentMessage.message = splitLine[1..lastElement].join(' ') 
      if @currentMessage.releventInfo()    
        totalLength = @jointClients.length
        count = 0
        while totalLength > count
          tempConnection = @jointClients[count]
          tempConnection.connection.puts @currentMessage.printMessage()
          count = count + 1
        end
      else
        client1.ErrorMessage(client1.error_CannotSendMessage)
      end           
    end  
  end
  def searchListForClient(list, name)
    totalLength = list.length
    count = 0
    while totalLength > count
      tempConnection = list[count]
      if tempConnection.Name != name
        count = count + 1
      else    
        return true
      end
    end
    return false
  end
   
  def removeClient(line, client1)
    headers,body = line.split       # Split response at first blank line into headers and body 
    if headers == "CLIENT_NAME:"      
        if !searchListForClient(@leftClients, body)
          if searchListForClient(@jointClients, body)        
            client1.connection.puts client1.printDetailsLeaving()
            @leftClients.push(self) 
          else
            puts "Client is not in chatroom"  
          end
        else
          puts "Client has already left this chatroom"
          @leftClients.push(client1) #keep the record of this client  
        end
    end 
  end
end

class Message                                              
  attr_accessor :JoinID, :RoomRef, :clientName, :message 
  def initialize()                  
   @RoomRef = 0
   @JoinID = 0 
   @clientName = "Default"
   @message = "Default"
  end
   def releventInfo()
     if @RoomRef != 0 and @JoinID != 0
      return true
    else
      return false
    end
  end
  def printMessage()
    return "CHAT: #@RoomRef\nCLIENT_NAME: #@clientName\nMESSAGE: #@message\n"    
  end
end

