require_relative 'board'
require_relative 'human_player'

class Checkers
  
  def initialize
    self.board = Board.new
    
    self.players = [
      HumanPlayer.new(self.board),
      HumanPlayer.new(self.board)
    ]
  end
  
  def play
    
    until over?
      current_player = self.players.first
      self.board.render
      current_player.take_turn
      
      self.players.rotate!
      self.board.flip!
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
