# A simple game of tic-tac-toe

TOKENS = ['X', 'O', '@', '#']
WINNING_CONDITIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                     [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                     [[1, 5, 9], [3, 5, 7]]

def display(board, player_list)
  system 'clear'
  puts "#{player_list[1][:name]}'s tokens are: #{player_list[1][:token]}"
  puts "#{player_list[2][:name]}'s tokens are: #{player_list[2][:token]}"
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

def empty_squares(board, player_list)
  board.select do |_, v|
    v != player_list[1][:token] && v != player_list[2][:token]
  end
end

def how_many_players
  players = 0
  loop do
    print 'How many players? (1 or 2): '
    players = gets.chomp.to_i
    break if players == 1 || players == 2
  end
  players
end

def get_player_name
  print "What is player's name? "
  gets.chomp
end

def create_players(num_of_players)
  player_list = {}
  if num_of_players == 2
    player_list[1] = { name: get_player_name, token: TOKENS[0], ai: false }
    player_list[2] = { name: get_player_name, token: TOKENS[1], ai: false }
  elsif num_of_players == 1
    player_list[1] = { name: get_player_name, token: TOKENS[0], ai: false }
    player_list[2] = { name: 'Computer', token: TOKENS[1], ai: true }
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

def winning_player(board, player_list)
  WINNING_CONDITIONS.each do |line|
    if line.all? { |square| board[square] == player_list[1][:token] }
      return player_list[1][:name]
    elsif line.all? { |square| board[square] == player_list[2][:token] }
      return player_list[2][:name]
    end
  end
  nil
end

def players_tie?(board, player_list)
  empty_squares(board, player_list).empty?
end

# Main game loop
loop do
  system 'clear'
  puts 'Welcome to Tic-Tac-Toe!'
  board = initialize_board
  num_of_players = how_many_players
  player_list = create_players(num_of_players)

  loop do
    display(board, player_list)
    player_selects_square(board, player_list[1], player_list)
    break if winning_player(board, player_list) ||
             players_tie?(board, player_list)

    display(board, player_list)
    player_selects_square(board, player_list[2], player_list)
    break if winning_player(board, player_list) ||
             players_tie?(board, player_list)
  end

  display(board, player_list)
  if winning_player(board, player_list)
    puts "#{winning_player(board, player_list)} wins!"
  else
    puts "It's a tie!"
  end

  print 'Would you like to play again? (y/n) '
  input = gets.chomp.downcase
  break if input != 'y'
end

puts 'Thanks for playing!'
