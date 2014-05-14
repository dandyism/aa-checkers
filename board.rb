require_relative 'man'

class Board
  
  SIZE = 10
  MEN  = 20
  
  def initialize
    self.matrix = empty_matrix
    place_men
  end
  
  def render
    system "clear"
    puts self
  end
  
  def move(start, target)
    
  end
  
  def to_s
    string = "  0123456789\n"
    
    self.matrix.each_index do |row|
      string += "#{row} "

      self.matrix.each_index do |col|
        man = self[[row, col]]

        if man.nil?
          string += " "
        else
          string += "#{man}"
        end
      end
      
      string += "\n"
    end
    
    string
  end
  
  def flip
    self.dup.flip!
  end
  
  def flip!
    self.matrix.reverse!
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
  
  protected
  attr_accessor :matrix
  attr_accessor :men
  
  def empty_matrix
    []
  end
  
  def place_men
    self.men = Hash.new { |h, k| h[k] = []}

    rank_depth  = MEN / (SIZE / 2)
    light_ranks = build_ranks(:light, 0, rank_depth)
    dark_ranks  = build_ranks(:dark,  SIZE - rank_depth, rank_depth)
    empty_ranks = empty_ranks(rank_depth, SIZE - rank_depth * 2)
    
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
