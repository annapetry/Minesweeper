class Game
  
end

class Board
  attr_reader :board
  def initialize
    @board = Array.new(9) { |i| Array.new(9) { |j| Tile.new(@board, [i, j]) } }
    seed_bombs
    
    @board.each do |x|
      x.each do |y|
        neighbor_bombs(y.position)
      end
    end
    
    board_state
    
  end
  
  def seed_bombs
    bomb_cords = []
    
    until bomb_cords.count == 20
      x = (0..8).to_a.sample
      y = (0..8).to_a.sample
      
      unless bomb_cords.include?([x, y])
        @board[x][y].bombed = true
        @board[x][y].state = @board[x][y].set_state
        @board[x][y].revealed = true        
      
        bomb_cords << [x, y]
      end
    end
    p bomb_cords
  end
  
  def board_state
    @board.each do |x|
      x.each do |y|
        y.set_state
      end
    end
  end
  
  
  def set_flag(position)
    @board[position[0]][position[1]].flagged = true
  end
  
  def neighbor_bombs(pos)
    board_pos = @board[pos[0]][pos[1]]
    adj_squares = board_pos.neighbors # this outputs a []
    counter = 0
    
    adj_squares.each do |sq|
      board_pos.value +=1 if @board[sq[0]][sq[1]].bombed
    end
    
    # puts "adjacent suqared: #{adj_squares}"
    board_state
  end
  
  # def get_square(position)
  #  @board[position[0]][positions[1]]
  # end
end

class Player
  def initialize
  end
  
  def choice
  end
  
  def set_a_flag #call set flag on board class
  end
  
  def choose_a_square
  end
  
end

class Tile
  attr_accessor :board, :bombed, :revealed, :state, :flagged, :value
  attr_reader :position

  def initialize(board = Board.new, pos = nil)
    @board = board
    @position = pos 
    @bombed = false
    @revealed = false
    @flagged = false
    @value = 0
    @state = 0
  end

  def set_state
    # return "*" if @revealed == false

    if @bombed
      return @state = "B"
    elsif @flagged
      return @state = "F"
    else
      return @state = @value
    end

  end

  NEIGHBOR_TILES =[
    [-1, 1],
    [-1, 0],
    [-1, -1],
    [0, 1],
    [0, -1],
    [1, 1],
    [1, 0],
    [1, -1]
  ]
  
  def neighbors
    return @neighbors if @neighbors
    @neighbors = []
    
    cur_x, cur_y = self.position
    
    NEIGHBOR_TILES.each do |(dx, dy)|
      new_position = [cur_x + dx, cur_y + dy]
      
      if new_position.all? { |coord| coord.between?(0, 8) }
        @neighbors << new_position
      end
    end
    
    @neighbors
  end
  
  # def inspect
  #
  # end
  
end



def testing
  puts "Testing Board class..."
  puts "\n\nCreates new board and populates with Tiles"
  game_board = Board.new
  
  game_board.board.each do |row|
    row.each do |col|
       print "#{col.state} "
    end
    puts ""
  end


  
  
  puts "\nPrint out bomb coords"
  # game_board.seed_bombs
  
  
  game_board.board.each do |row|
    row.each do |col|
       print "#{col.state} "
    end
    puts ""
  end
  
  p game_board.board
  
end



testing