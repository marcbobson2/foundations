require 'pry'
player_name=""
ROW_SEPARATOR = "-----+-----+-----".freeze
COL_SEPARATOR = "     |     |     ".freeze
PLAYER_MARKER = "X".freeze
COMPUTER_MARKER = "O".freeze
EMPTY_MARKER = " ".freeze
WIN_VECTORS = [
  [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6],
  [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]
].freeze

MAP_SQUARES_TO_VECTORS_TO_ANALYZE = {
  0 => ["C1", "R1", "D1"], 1 => ["C2", "R1"], 2 => ["C3", "R1", "D2"],
  3 => ["C1", "R2"], 4 => ["C2", "R2", "D1", "D2"], 5 => ["C3", "R2"],
  6 => ["C1", "R3", "D2"], 7 => ["C2", "R3"], 8 => ["C3", "R3", "D1"]
}.freeze

BOARD_CODES_TO_SQUARES_LOOKUP = {
  "C1" => [0, 3, 6], "C2" => [1, 4, 7], "C3" => [2, 5, 8],
  "R1" => [0, 1, 2], "R2" => [3, 4, 5],
  "R3" => [6, 7, 8], "D1" => [0, 4, 8], "D2" => [2, 4, 6]
}.freeze

TIE_MESSAGE = "All squares taken. It's a tie!".freeze

# logic rules for score_hash
# vector containing one 'x' and one 'o': -1
# empty vector: 1 pts
# vector with single x: 5 pts (value in blocking)
# vector with single o: 10 pts (value in setting up for win)
# 2 vectors with single x each: +15 pts [blocks sure win]
# 2 vectors with single o each: +30 pts [enables sure win]
# vector with 2 x's: 100 pts [block the sure win]
# vector with 2 o's: 1000 pts [computer wins]
SCORE_HASH = {
  [1, 1] => -1, [0, 0] => 1, [1, 0] => 5,
  [0, 1] => 10, [2, 0] => 100, [0, 2] => 1000
}.freeze

def initialize_board(board)
  9.times do |each_square|
    board[each_square] = EMPTY_MARKER
  end
end

def display_board(board)
  system("clear")
  puts ""
  3.times do |num|
    current_square = (num * 3)
    puts COL_SEPARATOR
    display_dynamic_row(board, current_square)
    puts COL_SEPARATOR
    puts ROW_SEPARATOR if num != 2
  end
  puts ""
end

def display_dynamic_row(board, current_square)
  puts "  " + board[current_square] + "  |  " + board[current_square + 1]\
  + "  |  " + board[current_square + 2]
end

def player_move!(brd, player_name)
  puts "#{player_name}, please make a move [1-9]?"
  player_move = ""
  loop do
    player_move = gets.chomp.to_i
    if !(1..9).to_a.include?(player_move)
      puts "Please enter a valid number from 1-9!"
    elsif brd[player_move - 1] != EMPTY_MARKER
      puts "The square you selected is already taken!  Please choose another."
    else
      break
    end
  end
  brd[player_move - 1] = PLAYER_MARKER
end

def check_for_win(brd, marker)
  WIN_VECTORS.each do |winning_squares|
    win_count = 0
    3.times do |counter|
      win_count += 1 if brd[winning_squares[counter]] == marker
    end
    return true if win_count == 3
  end
  false
end

def board_has_empty_spaces?(brd)
  brd.index(EMPTY_MARKER)
end

def find_open_squares(brd)
  viable_moves = []
  brd.each_index do |index|
    viable_moves << index if brd[index] == EMPTY_MARKER
  end
  viable_moves
end

def computer_move(brd)
  score_of_empty_squares = {}
  viable_moves = find_open_squares(brd)
  viable_moves.each do |empty_square|
    vectors_to_analyze = MAP_SQUARES_TO_VECTORS_TO_ANALYZE[empty_square]
    score_of_empty_squares[empty_square] =
      calculate_score_for_empty_square(vectors_to_analyze, brd)
  end
  final_move = determine_final_computer_move(score_of_empty_squares)
  brd[final_move] = COMPUTER_MARKER
end

def determine_final_computer_move(score_of_empty_squares)
  score_of_empty_squares.key(score_of_empty_squares.values.max)
end

def calculate_score_for_empty_square(vectors_to_analyze, brd)
  single_vector_score = 0
  combined_vector_score = 0
  count_of_vectors = { "X" => 0, "O" => 0 }

  vectors_to_analyze.each do |specific_vector|
    vector_to_score = BOARD_CODES_TO_SQUARES_LOOKUP[specific_vector]
    vector_contents = determine_vector_contents(vector_to_score, brd)
    single_vector_score = calculate_vector_score(vector_contents)
    count_of_vectors["X"] += 1 if single_vector_score == 5
    count_of_vectors["O"] += 1 if single_vector_score == 10
    combined_vector_score += single_vector_score
  end

  combined_vector_score += 15 if count_of_vectors["X"] >= 2
  combined_vector_score += 40 if count_of_vectors["O"] >= 2
  combined_vector_score
end

def determine_vector_contents(vector_to_score, brd)
  x_count = 0
  y_count = 0

  vector_to_score.each do |vector_location|
    value_for_each_square_in_vector = brd[vector_location]
    case value_for_each_square_in_vector
    when PLAYER_MARKER
      x_count += 1
    when COMPUTER_MARKER
      y_count += 1
    end
  end
  return x_count, y_count
end

def calculate_vector_score(vector_contents)
  score = SCORE_HASH[vector_contents]
  score
end

board_array = []
loop do
  system("clear")
  puts "Welcome to TicTacToe!"
  puts "Please tell us your name:"
  player_name = gets.chomp

  initialize_board(board_array)
  display_board(board_array)

  loop do
    player_move!(board_array, player_name)
    display_board(board_array)

    if check_for_win(board_array, PLAYER_MARKER)
      puts "You have won!"
      break
    end

    if !board_has_empty_spaces?(board_array)
      puts TIE_MESSAGE
      break
    end

    computer_move(board_array)
    display_board(board_array)

    if check_for_win(board_array, COMPUTER_MARKER)
      puts "Computer has won!"
      break
    end

    if !board_has_empty_spaces?(board_array)
      puts TIE_MESSAGE
      break
    end
  end
  puts "Do you want to play again? (y/n)"
  play_again = gets.chomp.downcase
  break if play_again.start_with?("n")
end

puts "Thanks, #{player_name}, for playing! We'll see you soon."
