# A simple game of Tic-Tac-Toe
# 1 to 4 players (if 1 player, computer is opponent)
# First player to win 3 rounds wins

require 'pry'

TOKENS = ['X', 'O', '@', '#'].freeze
WINNING_CONDITIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                     [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                     [[1, 5, 9], [3, 5, 7]].freeze

def clear_screen
  system 'clear'
end

def welcome
  clear_screen
  puts 'Welcome to Tic-Tac-Toe!'
  puts '--------------------------------------------------'
  puts '1 to 4 players (if 1 player, computer is opponent)'
  puts 'First player to win 3 rounds wins the game!'
  puts
end

def display_board(board, player_list)
  clear_screen
  display_score(player_list)
  display_players(player_list)
  display_current_board(board)
end

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
def display_current_board(board)
  puts
  puts '       |       |       '
  puts "   #{board[1]}   |   #{board[2]}   |   #{board[3]}   "
  puts '       |       |       '
  puts '-------+-------+-------'
  puts '       |       |       '
  puts "   #{board[4]}   |   #{board[5]}   |   #{board[6]}   "
  puts '       |       |       '
  puts '-------+-------+-------'
  puts '       |       |       '
  puts "   #{board[7]}   |   #{board[8]}   |   #{board[9]}   "
  puts '       |       |       '
  puts
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

def display_score(player_list)
  player_list.count.times do |n|
    name = player_list[n + 1][:name]
    score = player_list[n + 1][:score]
    puts "#{name} has #{score} points!"
  end
  puts '(First to 3 wins)'
  puts # spacing
end

def display_players(player_list)
  player_list.count.times do |n|
    name = player_list[n + 1][:name]
    token = player_list[n + 1][:token]
    puts "#{name}'s tokens are: #{token}"
  end
end

def initialize_board
  board = {}
  9.times { |n| board[n + 1] = (n + 1) }
  board
end

def mark_square(board, square, player_token)
  board[square] = player_token
end

def validate_square_choice(board, square)
  board[square] == square
end

def how_many_humans
  players = 0
  loop do
    print 'How many players? (up to 4): '
    players = gets.chomp.to_i
    break if (1..4).cover?(players)
    puts "Sorry, that's not a valid choice..."
  end
  players
end

def get_player_name(count)
  name = ''
  loop do
    print "What is player #{count}'s name? "
    name = gets.chomp
    break if name.size >= 3 && !name.include?(' ')
    puts 'Sorry, please enter a name with'
    puts 'at least 3 characters and no spaces...'
  end
  name
end

def create_human_players(num_of_humans, player_list)
  num_of_humans.times do |n|
    player_list[n + 1] = { name: get_player_name(n + 1),
                           token: TOKENS[n],
                           ai: false, score: 0 }
  end
end

def create_comp_and_human_players(player_list)
  player_list[1] = { name: get_player_name(1),
                     token: TOKENS[0],
                     ai: false, score: 0 }
  player_list[2] = { name: 'Computer',
                     token: TOKENS[1],
                     ai: true, score: 0 }
end

def initialize_players(num_of_humans)
  player_list = {}
  if num_of_humans > 1
    create_human_players(num_of_humans, player_list)
  elsif num_of_humans <= 1
    create_comp_and_human_players(player_list)
  end
  player_list
end

def player_selects_square(board, player, player_list)
  square = ''
  if player[:ai]
    sleep 1
    square = computer_selects_square(board, player_list)
  else
    square = human_selects_square(board, player)
  end
  mark_square(board, square, player[:token])
end

def computer_selects_square(board, player_list)
  square = computer_selects_aggressive(board, player_list)
  square = computer_selects_defensive(board, player_list) unless square
  square = empty_squares(board).values.sample unless square
  square
end

def human_selects_square(board, player)
  square = ''
  loop do
    print "#{player[:name]}, please choose a square: "
    square = gets.chomp.to_i
    break if validate_square_choice(board, square)
    puts 'Sorry, that is not a valid option!'
  end
  square
end

def computer_selects_aggressive(board, player_list)
  check_line(board, player_list[2])
end

def computer_selects_defensive(board, player_list)
  check_line(board, player_list[1])
end

def check_line(board, player)
  WINNING_CONDITIONS.each do |line|
    line_matches = line.count { |sqr| board[sqr] == player[:token] }
    open_sqrs = line.select { |sqr| square_empty?(board, sqr) }.size
    if line_matches == 2 && open_sqrs == 1
      return line.select { |sqr| square_empty?(board, sqr) }[0]
    end
  end
  nil
end

def winning_line?(board, line, player)
  line.all? { |square| board[square] == player[:token] }
end

def winning_player(board, player_list)
  player_list.count.times do |n|
    WINNING_CONDITIONS.each do |line|
      if winning_line?(board, line, player_list[n + 1])
        return player_list[n + 1]
      end
    end
  end
  nil
end

def players_tie?(board)
  empty_squares(board).empty?
end

def square_empty?(board, square)
  (1..9).cover?(board[square])
end

def empty_squares(board)
  board.select { |_, square_value| square_empty?(board, square_value) }
end

def player_turns(board, player_list, player_turn_order)
  loop do
    player_turn_order.each do |player|
      display_board(board, player_list)
      player_selects_square(board, player_list[player], player_list)
      break if winning_player(board, player_list) || players_tie?(board)
    end
    break if winning_player(board, player_list) || players_tie?(board)
  end
end

def initialize_player_turn_order(player_list)
  player_turn_order = []
  player_list.count.times { |n| player_turn_order << n + 1 }
  player_turn_order
end

def increment_player_turn_order(player_turn_order)
  player_turn_order.push(player_turn_order.shift)
end

def prepare_next_round
  print 'Preparing the next round '
  4.times do
    sleep 1
    print '. '
  end
end

def play_again?
  input = ''
  loop do
    print 'Would you like to play again? (y/n) '
    input = gets.chomp.downcase
    break if %w(y n yes no).include?(input)
    puts 'Sorry, that is not a valid option...'
  end
  %w(y yes).include?(input) ? true : false
end

loop do # new game loop
  welcome

  num_of_humans = how_many_humans
  player_list = initialize_players(num_of_humans)
  board = initialize_board
  player_turn_order = initialize_player_turn_order(player_list)
  round_winner = nil

  loop do # new round loop
    player_turns(board, player_list, player_turn_order)
    display_board(board, player_list)
    round_winner = winning_player(board, player_list)

    if round_winner
      round_winner[:score] += 1
      break if round_winner[:score] >= 3
      puts "#{round_winner[:name]} wins the round!"
    else
      puts "It's a tie!"
    end

    prepare_next_round
    increment_player_turn_order(player_turn_order)
    round_winner = nil
    board = initialize_board
  end

  # finish game and set up next round if desired
  display_board(board, player_list)
  puts "#{round_winner[:name]} is the champion!"
  break unless play_again?
end

puts 'Thanks for playing!'
