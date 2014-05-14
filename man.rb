# encoding: UTF-8

class Man
  
  DELTAS = [
    [ -1, 1],
    [ -1,-1]
  ]
  
  attr_reader :position
  
  def initialize(board, color)
    self.board, self.color = board, color
  end
  
  def position=(pos)
    unless self.position.nil?
      self.board[self.position] = nil
    end

    @position = pos
    self.board[pos] = self
  end
  
  def slide(pos)
    self.valid_moves.include?(pos) && self.position = pos
  end
  
  def valid_moves
    deltas = DELTAS

    positions = deltas.map do |drow, dcol|
      [self.position.first + drow,
       self.position.last + dcol]
    end

    positions.select { |position| self.board[position].nil? }
  end
  
  def to_s
    "●"
  end
  
  protected
  attr_accessor :board, :color
  
end
