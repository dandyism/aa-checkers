# encoding: UTF-8
require "colorize"

class Man
  
  DELTAS = [
    [ -1, 1],
    [ -1,-1]
  ]
  
  KING_ROWS = [0, 9]
  
  attr_reader :position, :king
  attr_accessor :color
  
  def initialize(board, color)
    self.board, self.color = board, color
    
    self.king = false
  end
  
  def position=(pos)
    unless self.position.nil?
      self.board[self.position] = nil
    end

    @position = pos
    unless pos.nil?
      self.board[pos] = self
      king_me! if king_me?
    end 
  end
  
  def slide(pos)
    self.valid_slides.include?(pos) && self.position = pos
  end

  def jump(pos)
    
    if self.valid_jumps.include?(pos)
      row_diff = pos.first - self.position.first
      col_diff = pos.last - self.position.last
      
      target_row = self.position.first + row_diff / 2
      target_col = self.position.last + col_diff / 2

      target = self.board[[target_row,target_col]]
      self.board.kill(target)
      self.position = pos
      return true
    end
    
    false
  end
  
  def valid_moves
    self.valid_slides + self.valid_jumps
  end

  def valid_slides
    deltas = self.deltas

    positions = deltas.map do |drow, dcol|
      [self.position.first + drow,
       self.position.last + dcol]
    end

    positions.select { |position| self.board[position].nil? }
  end
  
  def valid_jumps
    row, col = self.position
    
    enemy_squares = self.deltas.map do |dr, dc|
      [row + dr, col + dc]
    end
    
    enemy_squares.select! { |square| self.board.enemy?(square, self.color) }
    
    jump_squares = enemy_squares.map do |erow, ecol|
      drow = erow - row
      dcol = ecol - col
      
      [erow + drow, ecol + dcol]
    end
    
    jump_squares.select { |square| self.board[square].nil? }
  end
  
  def move(sequence)
    if valid_move_seq?(sequence)
      self.move!(sequence) or raise InvalidMoveError.new
    end
  end
  
  def valid_move_seq?(sequence)
    begin
      self.dup.move!(sequence)
    rescue InvalidMoveError => e
      true
    else
      false
    end
  end
  
  def move!(sequence)
    sequence[1..-1].each do |move|
      if sequence.size > 2
        self.jump(move) or raise InvalidMoveError.new
      else
        (self.slide(move) || self.jump(move)) or raise InvalidMoveError.new
      end
    end
  end

  def to_s
    color = (self.color == :light) ? :red : :black
    "●".colorize(color: color)
  end
  
  protected
  attr_accessor :board
  attr_writer :king
  
  def king_me?
    KING_ROWS.include?(self.position.first)
  end
  
  def king_me!
    self.king = true
  end

  def deltas
    deltas = DELTAS
    deltas += [[1, -1], [1, 1]] if self.king
    
    if self.color == :dark
      deltas.map! { |row, col| [row * -1, col] }
    end
    
    deltas
  end

end
