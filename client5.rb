require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 2500
IPAddress = Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]
chatroom = "distributedSystems"
clientName = "Gerard"

s = TCPSocket.open(hostname, port)

#test along with client1 for chat
s.puts "JOIN_CHATROOM: #{chatroom}\nCLIENT_IP: #{IPAddress}\nPORT: #{port}\nCLIENT_NAME: #{clientName}\n"
s.puts "CHAT: #{2}\nJOIN_ID: #{2}\nCLIENT_NAME: #{clientName}\nMESSAGE: #{"Gerard is here"}\n"

begin
  while line = s.gets   # Read lines from the socket
    print line
  end 
end until line == "Closing the connection." 
puts "Connection Lost"     
s.close               # Close the socket when done
