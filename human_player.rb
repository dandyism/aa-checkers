require_relative 'invalid_move_error'
require_relative 'player'

class HumanPlayer < Player
  
  def initialize(board, color)
    super
    
    self.stream = $stdin
  end
  
end
