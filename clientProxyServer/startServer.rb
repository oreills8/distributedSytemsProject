require 'socket'                                            # Get sockets from stdlib
require 'thread'
require './server'
require './client'

server1 = Server.new(Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3])      #create new server

                          
workers = (0...4).map do # make 4 threads
  Thread.new do
    begin
      clientAccepted = false   
      while server1.IsOpen
        if (server1.enteringClients.length > 0) and (clientAccepted == false)
          server1.ClientCount = server1.ClientCount + 1
          client1 = Client.new(server1.ClientCount, server1.enteringClients.pop)      #create new client # get the socket from the queue
          clientAccepted = true
        elsif clientAccepted
          while line = client1.connection.gets   # Read lines from the socket
            puts line                       # And print with platform line terminator
            server1.messageReceived(line, client1)
          end          
        end                                                                 
      end
    rescue ThreadError
    end
  end
end; 

while server1.IsOpen                         #while socket is open                                            
  server1.enteringClients.push(server1.socket.accept)  #take in new clients and push into queue
end
workers.map(&:join);    #stop all threads when they have finished running
server1.socket.close  #close the socket
puts"Server Closed"                                        #when socket is closed
