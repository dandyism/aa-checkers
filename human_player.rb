class HumanPlayer
  
  def initialize(board)
    self.board = board
  end
  
  def take_turn
    move = get_move
    self.board.move(*move)
  end
  
  protected
  attr_accessor :board
  
  def get_move
    move = gets.chomp
    parse_move(move)
  end
  
  def parse_move(move)
    start, target = move.split(",")
    start = start.split("")
    target = target.split("")
    [start, target]
  end
  
end