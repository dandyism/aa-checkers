require_relative 'invalid_move_error'

class HumanPlayer
  
  def initialize(board)
    self.board = board
  end
  
  def take_turn
    seq = get_move
    man = take_man(seq.shift)

    if man.nil?
      raise InvalidMoveError.new
    end
    
    man.move(seq)
  end
  
  protected
  attr_accessor :board
  
  def take_man(position)
    self.board[position]
  end
  
  def get_move
    move = gets.chomp
    parse_input(move)
  end

  def parse_input(move)
    chain = move.split(",")
    chain.map { |link| parse_move(link) }
  end
  
  def parse_move(move)
    move.split("").map { |digit| Integer(digit) }
  end
  
end
