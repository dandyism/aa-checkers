# encoding: UTF-8

class Man
  
  DELTAS = [
    [ -1, 1],
    [ -1,-1]
  ]
  
  attr_reader :position
  attr_accessor :color
  
  def initialize(board, color)
    self.board, self.color = board, color
  end
  
  def position=(pos)
    unless self.position.nil?
      self.board[self.position] = nil
    end

    @position = pos
    self.board[pos] = self unless pos.nil?
  end
  
  def slide(pos)
    self.valid_moves.include?(pos) && self.position = pos
  end

  def jump(pos)
    row_diff = pos.first - self.position.first
    col_diff = pos.last  - self.position.last
    delta    = [row_diff, col_diff]

    # FIXME: This code assumes the board flips every turn.
    if row_diff == -2 && col_diff.abs == 2 && self.board[pos].nil?
      target_row = self.position.first + row_diff / 2
      target_col = self.position.last + col_diff / 2

      target = self.board[[target_row,target_col]]

      if target.color != self.color
        self.board.kill(target)

        self.position = pos
        return true
      end
    end

    false
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
  attr_accessor :board

end
