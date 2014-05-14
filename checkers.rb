require_relative 'board'
require_relative 'human_player'

class Checkers
  
  def initialize
    self.players = [
      HumanPlayer.new,
      HumanPlayer.new
    ]
    
    self.board = Board.new
  end
  
  def play
    
    until over?
      current_player = self.players.first
      self.board.render
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