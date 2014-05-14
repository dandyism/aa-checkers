class Board
  
  SIZE = 10
  MEN  = 20
  
  def initialize
    build_matrix
    place_men
  end
  
  protected
  attr_accessor :matrix
  attr_accessor :men
  
  def build_matrix
    Array.new(SIZE) { Array.new(SIZE) }
  end
  
  def place_men
    self.men[:light] = [Man.new(self, :light)] * MEN
    self.men[:dark]  = [Man.new(self, :dark)]  * MEN
    
    self.matrix.flatten.each_with_index do |el, i|
      # TODO: Place men
    end
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
  
end
