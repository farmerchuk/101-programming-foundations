# a simple game of tic-tac-toe
require 'pry'

TOKENS = ['X', 'O', '@', '#']
WINNING_CONDITIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                     [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                     [[1, 5, 9], [3, 5, 7]]

def display_board(board, player_list)
  system 'clear'
  display_score(player_list)
  player_list.count.times do |n|
    name = player_list[n + 1][:name]
    token = player_list[n + 1][:token]
    puts "#{name}'s tokens are: #{token}"
  end
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

def display_score(player_list)
  player_list.count.times do |n|
    name = player_list[n + 1][:name]
    score = player_list[n + 1][:score]
    puts "#{name} has #{score} points!"
  end
  puts "(First to 3 wins)"
  puts
end

def initialize_board
  board = {}
  9.times { |n| board[n + 1] = (n + 1) }
  board
end

def mark_square(board, square, player_token)
  board[square] = player_token
end

def validate_choice(board, square)
  board[square] == square
end

def how_many_players
  players = 0
  loop do
    print 'How many players? (up to 4): '
    players = gets.chomp.to_i
    break if (1..4).include?(players)
  end
  players
end

def get_player_name(count)
  print "What is player #{count}'s name? "
  gets.chomp
end

def create_players(num_of_players)
  player_list = {}
  if num_of_players > 1
    num_of_players.times do |n|
      player_list[n + 1] = { name: get_player_name(n + 1), token: TOKENS[n],
                         ai: false, score: 0 }
    end
  elsif num_of_players <= 1
    player_list[1] = { name: get_player_name(1), token: TOKENS[0],
                       ai: false, score: 0 }
    player_list[2] = { name: 'Computer', token: TOKENS[1],
                       ai: true, score: 0 }
  end
  player_list
end

def player_selects_square(board, player, player_list)
  input = ''
  if player[:ai]
    sleep 1
    input = empty_squares(board, player_list).values.sample
  else
    loop do
      print "#{player[:name]}, please choose a square: "
      input = gets.chomp.to_i
      break if validate_choice(board, input)
      puts 'Sorry, that is not a valid option!'
    end
  end
  mark_square(board, input, player[:token])
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

def players_tie?(board, player_list)
  empty_squares(board, player_list).empty?
end

def empty_squares(board, player_list)
  board.select do |_, v|
    v != player_list[1][:token] && v != player_list[2][:token]
  end
end

def player_turn(board, player_list)
  player_list.count.times do |n|
    display_board(board, player_list)
    player_selects_square(board, player_list[n + 1], player_list)
    if winning_player(board, player_list) || players_tie?(board, player_list)
      return 1
    end
  end
  nil
end


loop do  # new game loop
  system 'clear'
  puts 'Welcome to Tic-Tac-Toe!'

  num_of_players = how_many_players
  player_list = create_players(num_of_players)
  round_winner = nil
  board = initialize_board

  loop do  # new round loop
    loop do
      break if player_turn(board, player_list)
    end

    display_board(board, player_list)
    round_winner = winning_player(board, player_list)

    if round_winner
      round_winner[:score] += 1
      break if round_winner[:score] >= 3
      puts "#{round_winner[:name]} wins the round!"
      print 'Preparing the next round '
      4.times do
        sleep 1
        print '. '
      end
    else
      puts "It's a tie!"
    end
    round_winner = nil
    board = initialize_board
  end

  display_board(board, player_list)
  puts "#{round_winner[:name]} is the champion!"
  print 'Would you like to play again? (y/n) '
  input = gets.chomp.downcase
  break if input != 'y'
end

puts 'Thanks for playing!'
