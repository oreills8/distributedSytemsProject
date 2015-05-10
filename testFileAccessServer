require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 2600

s = TCPSocket.open(hostname, port)


#s.puts "HELO Sarah"
#s.puts "CHATROOM: #{1}\nJOIN_ID: #{1}\nDOWNLOAD: file2\n"
#s.puts "CHATROOM: #{1}\nJOIN_ID: #{1}\nUPLOAD: Information for the new file.\nAnother line of it. \nFINISHED_UPLOADING"
s.puts "CHATROOM: #{1}\nJOIN_ID: #{1}\nAVAILABLE_FILES\n"
s.puts "KILL_SERVICE\n"

while line = s.gets   # Read lines from the socket
  print line
end
puts "here here"
s.close               # Close the socket when done
