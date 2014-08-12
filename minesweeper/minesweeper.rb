require 'debugger'


class Game
  attr_accessor :board
  
  def initialize
    @board = Board.new
  end
  
  def play_game
    # welcome message
    puts "Welcome to Minesweeper!"
    puts "We're about to sweep your mind..."
    
    game_state = true
    
    while game_state
      display_board_state
      # ask Reveal or Flag
      option = reveal_or_flag
      # get coordinate
      position = user_enter_position # returns an array
      # debugger
      # board_pos = @board.board[position[0]][position[1]]
      
      if @board.board[position[0]][position[1]].revealed == true
        puts "That has already been revealed!"
        redo
      end 
        
        
      case option
      when "R"
        @board.reveal_neighbors(position)
      when "F"
        @board.set_flag(position)
      end
      
      # check to see lost?
      if lost?(position) && option == "R"  
        puts "You LOST!"
        game_state = false
        # check to see won?
        
      elsif won?(position)
        puts "You WON!"
        game_state = false
      end
    
      @board.board_state
    end
  end
  
  
  def won?(pos)
    count = 0 
    @board.board.each do |row|
      row.each do |value|
        next if value.revealed
        count += 1
      end
    end
    
    count == @board.bombs ? true : false
  end
  
  def lost?(pos)
    return true if @board.board[pos[0]][pos[1]].bombed
    false
  end
  
  def display_board_state
    @board.board.each do |row|
      row.each do |col|
         print "#{col.state} "
      end
      puts ""
    end
  end
  
  def reveal_or_flag
    puts "Enter R for reveal or F for flag"
    option = gets.chomp
    unless (option == "R" || option == "F")
      puts "Invalid Option"
      return reveal_or_flag
    end
    option
  end # returns R or F
  
  def user_enter_position
    puts "Enter position (x,y)"
    position_string = gets.chomp
    return user_enter_position if position_string.include?("nil")
    
     string_split = position_string.split(',')
     
     x_pos = string_split[0].to_i
     y_pos = string_split[1].to_i
     
     [x_pos, y_pos]
    
  end

end

class Board
  attr_accessor :board, :bombs
  
  def initialize
    @board = Array.new(9) { |i| Array.new(9) { |j| Tile.new(@board, [i, j]) } }
    @bombs = 20
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
    
    until bomb_cords.count == @bombs
      x = (0..8).to_a.sample
      y = (0..8).to_a.sample
      
      unless bomb_cords.include?([x, y])
        @board[x][y].bombed = true
        @board[x][y].state = @board[x][y].set_state
        # @board[x][y].revealed = true
      
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
  
  # def [](pos)
  #   x, y = pos[0], pos[1]
  #   @board[x][y]
  # end
  
  def set_flag(position)
    @board[position[0]][position[1]].flagged = true
    @board[position[0]][position[1]].set_state
    
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
  
  def reveal_neighbors(pos)
    board_position = @board[pos[0]][pos[1]]
    
    queue = [board_position]

    until queue.empty?
      current_position = queue.shift
      current_position.revealed = true
  
      if current_position.value == 0
        current_position.neighbors.each do |neighbor|
          # neighbor_position = @board[neighbor[0]][neighbor[1]]
          # queue << (neighbor_position)
          queue <<  @board[neighbor[0]][neighbor[1]] unless @board[neighbor[0]][neighbor[1]].revealed
          # debugger
        end
      end
  
    end
  end
  # def get_square(position)
  #  @board[position[0]][positions[1]]
  # end
end

# class Player
#   def initialize
#   end
#
#   def choice
#   end
#
#   def set_a_flag #call set flag on board class
#   end
#
#   def choose_a_square
#   end
  


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

  # def [](pos)
  #   x, y = pos[0], pos[1]
  #   @rows[x][y]
  # end
  
  def set_state
    return @state = "F" if @flagged
    return @state = "*" if @revealed == false
    

    if @bombed
      return @state = "B"
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


if __FILE__ == $PROGRAM_NAME
  game = Game.new
  
  game.play_game
end



#
# def testing
#   puts "Testing Board class..."
#   puts "\n\nCreates new board and populates with Tiles"
#   game_board = Board.new
#
#   game_board.board.each do |row|
#     row.each do |col|
#        print "#{col.state} "
#     end
#     puts ""
#   end
#
#
#
#
#   puts "\nPrint out bomb coords"
#   # game_board.seed_bombs
#
#
#   game_board.board.each do |row|
#     row.each do |col|
#        print "#{col.state} "
#     end
#     puts ""
#   end
#
#   p game_board.board
#
# end
#
#
