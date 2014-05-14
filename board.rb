class Board
  
  SIZE = 10
  MEN  = 20
  
  def initialize
    self.matrix = empty_matrix
    place_men
  end
  
  def render
    puts self
  end
  
  def to_s
    string = ""
    
    self.matrix.each_index do |row|
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
    Array.new(SIZE) { Array.new(SIZE) }
  end
  
  def place_men
    self.men = {}
    
    self.men[:light] = [Man.new(self, :light)] * MEN
    self.men[:dark]  = [Man.new(self, :dark)]  * MEN

    i = 0
    (0..3).each do |row|
      (0...SIZE).each do |col|
        if col % 2 == 0
          man = self.men[:dark][i]
          i += 1
          
          unless man.nil?
            man.position = [row, col]
          end
        end
      end
    end
    
    i = 0
    (5...SIZE).each do |row|
      (0...SIZE).each do |col|
        if col % 2 == 0
          man = self.men[:light][i]
          i += 1
          
          unless man.nil?
            man.position = [row, col]
          end
        end
      end
    end
    
    nil
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
