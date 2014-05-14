class Man
  
  attr_reader :position
  
  def initialize(board, color)
    self.board, self.color = board, color
  end
  
  def position=(pos)
    unless self.position.nil?
      self.board[pos] = nil
    end
    
    self.board[pos] = self
  end
  
  protected
  attr_accessor :board, :color
  
end