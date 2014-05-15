require "socket"

require_relative 'player'

class RemotePlayer < Player
  
  PORT = 2000
  
  def initialize(board, color, address = nil)
    super(board, color)
    
    if address.nil?
      puts "Waiting for client to connect..."
      server = TCPServer.new(PORT)
      self.stream = server.accept
      
      puts "Client connected!"
    end
    
    sleep 2
    
  end
  
end