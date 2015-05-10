require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 2800
IPAddress = Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]
chatroom = "distributedSystems"
clientName = "Steven"
    
s = TCPSocket.open(hostname, port)

#s.puts "CHATROOM: #{1}\nJOIN_ID: #{1}\nDIRECTORY: Research Proposal file\n"
s.puts "CHATROOM: #{1}\nJOIN_ID: #{1}\nUPDATE_FILE: file1\nSERVER: 0\n"
s.puts "KILL_SERVICE\n"

begin
  while line = s.gets   # Read lines from the socket
    print line
  end 
end until line == "Closing the connection." 
puts "Connection Lost"     
s.close               # Close the socket when done
