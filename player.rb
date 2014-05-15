class Player
  
  attr_accessor :color
  
  def initialize(board, color)
    self.board, self.color = board, color
  end
  
  def take_turn
    seq = get_move
    man = take_man(seq.shift)

    if man.nil? || man.color != self.color
      raise InvalidMoveError.new
    end
    
    man.move(seq)
  end
  
  protected
  attr_accessor :board, :stream
  
  def take_man(position)
    self.board[position]
  end
  
  def get_move
    move = self.stream.gets.chomp
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