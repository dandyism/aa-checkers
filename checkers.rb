require_relative 'board'
require_relative 'human_player'

class Checkers
  
  def initialize
    self.board = Board.new
    
    self.players = [
      HumanPlayer.new(self.board, :light),
      HumanPlayer.new(self.board, :dark)
    ]
  end
  
  def play
    
    until over?
      current_player = self.players.first
      self.board.render
      
      begin
        current_player.take_turn        
      rescue InvalidMoveError, ArgumentError
        puts "Invalid Move!"
        retry
      end
      
      self.players.rotate!
    end
    
    self.board.render
    winner = winner?
    puts "#{winner} has won."
    
  end
  
  def over?
  end
  
  protected
  attr_accessor :board, :players
  
end

if __FILE__ == $PROGRAM_NAME
  Checkers.new.play
end
