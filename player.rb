class Player
  
  attr_accessor :color
  
  def initialize(board, color)
    self.board, self.color = board, color
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