# Ruby Individual Assignment
# Created by Georgica Bors

# Importing the required gems
# 'console_splash' is used to create the splash screen
# Each block will consist of 2 space characters
# The colour of each block will be changed using 'colorize'
 
require 'console_splash'
require 'colorize'

# Global variables
# The array 'colours' contains all possible colours of each block
# Initial size of board is 14x9

$best_score = 0
$board_width = 14
$board_height = 9
$colours = [:red,:blue,:green,:yellow,:cyan,:magenta]

# Returns an array 'board' of rows
# Each row is an array with randomly assigned values from 'colours' array
def get_board(width, height)
  # Create a new 2D array
  board = Array.new($board_height) {Array.new($board_width)}
  # Each element will be assigned a random value from 'colours'
  # That is done by choosing a random index of the 'colours' array
  (0...$board_height).each do |row|  
    (0...$board_width).each do |cell|
      board[row][cell] = $colours[rand(6)]  
    end
  end
  # Return board
  return board
end

# update_board method used to update the board after the user choose a new colours
# First the top left field is updated to the new colour
# For each neighbour field that has the same colour as the first field 
# had before changing it, recursively update that field as well
def update_board(board,new_colour,old_colour,i,j)
  
  # Update field colour
  board[i][j]= new_colour
  
  # Check if there is a neighbour on top and if that neighbour has the same colour as the previous colour
  # If yes, then that neighbour is chosen to be updated in turn
  if (i-1) >=0 && board[i-1][j] == old_colour
    board = update_board(board,new_colour,old_colour,i-1,j)  
  end
  
  # Check if there is a neighbour on the right and if that neighbour has the same colour as the previous colour
  # If yes, then that neighbour is chosen to be updated in turn
  if (j+1) < $board_width && board[i][j+1] == old_colour
    board = update_board(board,new_colour,old_colour,i,j+1)
  end
  # Check if there is a neighbour on the buttom and if that neighbour has the same colour as the previous colour
  # If yes, then that neighbour is chosen to be updated in turn
  if (i+1) <$board_height && board[i+1][j] == old_colour
    board = update_board(board,new_colour,old_colour,i+1,j)   
  end
  # Check if there is a neighbour on the left and if that neighbour has the same colour as the previous colour
  # If yes, then that neighbour is chosen to be updated in turn
  if (j-1) >=0 && board[i][j-1] == old_colour
    board = update_board(board,new_colour,old_colour,i,j-1)    
  end
  # return board
  return board
end

# Method used to display the menu
def display_menu
  # print the options
  puts "Main menu:"
  puts "s = Start game"
  puts "c = Change size"
  puts "q = Quit"
  # print the best score
  # if there is no best score yet a message is displayed instead
  if $best_score == 0
    puts "No games played yet"
  else
    puts "Best game: #{$best_score} turns"
  end
  
  # Then ask for input for one of the options
  print "Please enter your choice: "
  
end

# Method used to find the option selected by the user in main menu
def get_choice input

  if input == "s"
    # clear the screen
    system "clear"
    # start game
    start_game
  elsif input == "c"
    change_size
  elsif input == "q"
    # terminate the program
    exit
  end
end


# Start the game

def start_game 
  
  number_of_turns = 0
  progress = 0
  # get a random board
  board = get_board($board_width,$board_height)
  # get completion of the game
  progress = get_progress (board)
  # display the board on screen
  display_board(board,number_of_turns,progress)
  
  # start a loop which finishes when the completion of the game is 100%
  begin 
    # get colour chosen by the user
    colour = get_colour
    
    # if chosen colour is 'q', then return to main menu
    if colour == "q" then
      return
    end
    
    # if the input is invalid ask the user to input the colour again
    while colour == "invalid" do
      puts "Invalid input! Try again!"
      print "Please enter your choice: " 
      colour = get_colour
      if colour == "q" then
        return
      end
    end
    # remember the old colour of the left top corner of the board
    old_colour = board[0][0]
    # then update the board using the new colour given by the user
    board = update_board(board,colour,old_colour,0,0)
    # increment the number of turns
    number_of_turns += 1
    # calculate the current completion
    progress = get_progress (board)
    # clear the console for a better gameplay
    system "clear" 
    # the display the updated board on the screen
    display_board(board,number_of_turns,progress)   
    
  end until progress ==100 
  # Update best score 
  if number_of_turns < $best_score || $best_score == 0
    $best_score = number_of_turns
  end
  
  # When the game finishes display a message
  puts "You won after #{number_of_turns} turns"
    
  # Then wait for the user to confirm by pressing enter key 
  input = gets 
  until input == "\n" do
  input = gets
  end
 
end

# Method used to calculate the completion of the game
# Count all the blocks the have the same colour as the top-left corner
# The completion is then calculated by diving the counter by the total number of blocks *100
# The result is then converted to an integer
def get_progress(board)
  counter = 0
  total = $board_width * $board_height
  board.each do |row|
    row.each do |cell|  
      if cell == board[0][0]
        counter+=1
      end
    end
  end
  return (counter/total.to_f * 100).to_i
end
    
# Method used to return the colour given by the user
def get_colour
  colour = gets.chomp.downcase
  
  if colour =="q" then
    colour = "q"   
  elsif colour == "r" 
    colour = :red
  elsif colour == "b"
    colour = :blue
  elsif colour == "g"
    colour = :green
  elsif colour == "y"
    colour = :yellow
  elsif colour == "c"
    colour = :cyan
  elsif colour == "m"
    colour = :magenta
  else
    # if the input is none of the above colours or 'q'
    # then the input must be invalid 
    colour = "invalid"   
  end
  # return colour
  return colour
end
  
# Method used to display the board on the screen
def display_board(board,number_of_turns,progress)
  board.each do |row|
    row.each do |cell| 
      # Each element of the board contains 2 space characters
      # 'colorize' gem is used to print coloured text
      # and 'cell' contains the colour which to be used
      print "  ".colorize(:background=>cell)
    end
    puts ""
  end
  # Show the number of turns and completion
  puts "Current number of turns: #{number_of_turns}"
  puts "Current completion: #{progress}%"
  
  # Ask the user to input the colour as long as the game is not finished
  if progress < 100
    print "Choose a colour: "
  end
  
end
      
# Method used to change the size of the board
def change_size()
  
  print "Width (Currently #{$board_width})? "
  # Validate the input
  # If the user input is invalid, the user will be asked to try again
  valid = false
  until valid == true do
    input = gets.chomp
    if input.to_i.to_s == input then
      $board_width = input.to_i
      valid = true    
    else
      puts "Input is not an integer! Try again: "  
    end
  end
 
  print "Height (Currently #{$board_height})? "
  # Validate the input
  # If the user input is invalid, the user will be asked to try again
  valid = false  
  until valid == true do
    input = gets.chomp
    if input.to_i.to_s == input then
      $board_height = input.to_i
      valid = true    
    else
      puts "Input is not an integer! Try again: "  
    end
  end

  # The best score is reset when the board size is changed
  $best_score = 0
end

# Method used to create the splash screen
def start_splash
  # Clear the console
  puts "\e[H\e[2J" 
  
  # Create a new splash object 
  splash = ConsoleSplash.new(13, 40) # 13 lines, 40 columns
  
  # Add header to the splash console
  splash.write_header("Welcome to Flood-It", "Georgica Bors", "1.0")
  
  # Add text to the splash console
  splash.write_center(-3, "<Press enter to continue>")
  
  # Select the pattern of the border of the splash screen
  splash.write_horizontal_pattern("*")
  splash.write_vertical_pattern("*")
  
  # Draw the splash screen
  splash.splash
  
end
    
    
# Main Program 

# display the splash screen
start_splash
puts " "
    
# Then wait for the user to press enter key
input = gets
until input == "\n" do
  input = gets
end

# clear screen
puts "\e[H\e[2J"
input = ""
    
# Display menu
# Get option from user
# And loop until input user wants to quit the game
until input=="q" do
  display_menu
  input = gets.chomp.downcase
  get_choice(input)
end

# END
  
  

