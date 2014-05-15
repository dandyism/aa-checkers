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

  def jump(pos)
    row_diff = pos.first - self.position.first
    col_diff = pos.last  - self.position.last
    delta    = [row_diff, col_diff]

    if row_diff == -2 && col_diff.abs == 2 && self.board[pos].nil? && self.board[pos].color != self.color
      target_row = self.position.first 
      target_col = self.position.last

      #FIXME: Move target removal to board function?
      target = self.board[target_row][target_col]
      self.board.men[target.color].delete(target)
      target.position = nil

      self.position = pos
      true
    else
      false
    end

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
