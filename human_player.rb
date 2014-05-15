require_relative 'invalid_move_error'

class HumanPlayer
  
  def initialize(board)
    self.board = board
  end
  
  def take_turn
    move = get_move
    man = take_man(move.first)

    if man.nil?
      raise InvalidMoveError.new
    end
    
    (man.slide(move.last) || man.jump(move.last)) or raise InvalidMoveError.new
  end
  
  protected
  attr_accessor :board
  
  def take_man(position)
    self.board[position]
  end
  
  def get_move
    move = gets.chomp
    parse_move(move)
  end
  
  def parse_move(move)
    start, target = move.split(",")
    start = start.split("")
    target = target.split("")
    start.map! {|e| Integer(e) }
    target.map! {|e| Integer(e) }
    [start, target]
  end
  
end
