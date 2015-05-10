require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 2700
IPAddress = Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]
chatroom = "distributedSystems"
clientName = "Steven"
    
s = TCPSocket.open(hostname, port)

s.puts "CHATROOM: #{1}\nJOIN_ID: #{1}\nLOCK: file1\n"
s.puts "KILL_SERVICE\n"
     
puts "start waiting"
while line = s.gets   # Read lines from the socket
  print line   
end
puts "stop waiting"
s.close               # Close the socket when done
