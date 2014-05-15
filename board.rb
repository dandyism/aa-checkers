require_relative 'man'

class Board
  
  SIZE = 10
  RANK_DEPTH = 4
  
  def initialize
    self.matrix = empty_matrix
    place_men
  end
  
  def render
    system "clear"
    puts self
  end
  
  def to_s
    output = []
    background_color = :red
    
    self.matrix.each_index do |row|
      row_string = ""
      
      self.matrix.each_index do |col|
        man = self[[row, col]]
        tile = ""

        if man.nil?
          tile += "   "
        else
          tile += " #{man} "
        end

        row_string += tile.colorize(background: background_color)

        unless col == SIZE - 1
          background_color = (background_color == :red) ? :light_black : :red
        end
      end
      
      output << row_string
    end
    
    output = output.each_with_index.map { |row, i| "#{i} #{row}" }
    output = ["   0  1  2  3  4  5  6  7  8  9"] + output
    output.join("\n")
  end
  
  def enemy?(pos, friendly_color)
    !self[pos].nil? && self[pos] != friendly_color
  end
  
  def dup
    dupped_board  = Board.new
    dupped_matrix = self.matrix.dup.map { |row| row.dup }
    dupped_men    = Hash.new { |h, k| h[k] = [] }
    
    self.men[:light].each { |man| dupped_men[:light] << Man.new(self, :light) }
    self.men[:dark].each  { |man| dupped_men[:dark] << Man.new(self, :dark) }
    
    dupped_board.matrix = dupped_matrix
    dupped_board.men    = dupped_men
    
    dupped_board
  end
  
  def [](position)
    row, col = position
    self.matrix[row][col]
  end
  
  def []=(position, value)
    row, col = position
    self.matrix[row][col] = value 
  end

  def kill(target)
    target.position = nil
    self.men[target.color].delete(target)

    nil
  end
  
  def all_dead?(color)
    self.men[color].empty?
  end
  
  def men_can_move?(color)
    !self.men[color].all? { |man| man.valid_moves.empty? }
  end
  
  protected
  attr_accessor :matrix
  attr_accessor :men
  
  def empty_matrix
    []
  end
  
  def place_men
    self.men = Hash.new { |h, k| h[k] = []}

    light_ranks = build_ranks(:light, 0, RANK_DEPTH)
    dark_ranks  = build_ranks(:dark,  SIZE - RANK_DEPTH, RANK_DEPTH)
    empty_ranks = empty_ranks(RANK_DEPTH, SIZE - RANK_DEPTH * 2)
    
    self.matrix = dark_ranks + empty_ranks + light_ranks

    set_men_positions
    
    nil
  end
  
  def build_ranks(color, start_pos, depth)
    head_count = (depth * SIZE) / 2
    men = [Man] * head_count
    empties = [nil] * head_count
    
    men.map! { |man| man.new(self, color) }
    men.each { |man| self.men[color] << man }
    
    ranks = men.zip(empties).flatten.each_slice(SIZE).to_a
    stagger_ranks(ranks)
  end
  
  def stagger_ranks(ranks)
    ranks.each_index do |i|
      ranks[i].rotate! if i % 2 == 0
    end
  end
  
  def empty_ranks(start_pos, depth)
    empties = [nil] * (depth * SIZE)
    empties.each_slice(SIZE).to_a
  end

  def set_men_positions
    self.matrix.each_index do |row|
      self.matrix[row].each_index do |col|
        man = self.matrix[row][col]
        man && man.position = [row, col]
      end
    end
  end
  
end
