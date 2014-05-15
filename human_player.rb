require_relative 'invalid_move_error'
require_relative 'player'

class HumanPlayer < Player
  
  def take_turn
    seq = get_move
    man = take_man(seq.shift)

    if man.nil? || man.color != self.color
      raise InvalidMoveError.new
    end
    
    man.move(seq)
  end
  
end
