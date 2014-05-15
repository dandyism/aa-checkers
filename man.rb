# encoding: UTF-8
require "colorize"

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
    sequence.each do |move|
      if sequence.size > 1
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

  def deltas
    if self.color == :dark
      DELTAS.map { |row, col| [row * -1, col] }
    else
      DELTAS
    end
  end

end
