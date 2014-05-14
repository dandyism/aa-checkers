class Board
  
  SIZE = 10
  
  def initialize
    build_matrix
  end
  
  protected
  attr_accessor :matrix
  
  def build_matrix
    Array.new(SIZE) { Array.new(SIZE) }
  end
  
end