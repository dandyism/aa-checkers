class Checkers
  
  def initialize
    self.players = [
      HumanPlayer.new,
      HumanPlayer.new
    ]
  end
  
  def play
    
    until over?
      current_player = self.players.first
      self.board.render
      self.players.rotate!
    end
    
    self.board.render
    winner = winner?
    puts "#{winner} has won."
    
  end
  
  def over?
    self.dark_men.empty? || self.light_men.empty?
  end
  
  protected
  attr_accessor :board, :dark_men, :light_men, :players
  
end