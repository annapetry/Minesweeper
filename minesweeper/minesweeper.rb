class Game
  
end

class Board
  attr_reader :board
  def initialize
    @board = Array.new(9) { |i| Array.new(9) { |j| Tile.new(@board,[i,j]) }}
    seed_bombs
  end
  
  def seed_bombs
    bomb_cords = []
    
    until bomb_cords.count == 5
      x = (0..8).to_a.sample
      y = (0..8).to_a.sample
      
      unless bomb_cords.include?([x, y])
        @board[x][y].bombed = true
        bomb_cords << [x, y]
      end
      
    end
    p bomb_cords
  end
  
  def get_square(position)
   @board[position[0]][positions[1]]
  end
end

class Player
  
end

class Tile
  attr_accessor :board, :bombed
  attr_reader :revealed, :flagged, :value, :position, :state

  def initialize(board = Board.new, pos = nil, revealed = false, bombed = false, flagged = false, value = " ")
    @board = board
    @position = pos 
    @bombed = bombed
    @revealed = revealed
    @flagged = flagged
    @value = value
    @state =  set_state
  end

  def set_state
    return "*" if @revealed == false

    if @bombed
      return "B"
    elsif @flagged
      return "F"
    else
      return @value
    end

  end


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
  game_board.seed_bombs
  
  
end



testing