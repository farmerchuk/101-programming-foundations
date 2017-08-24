# a simple game of tic-tac-toe

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
  puts '(First to 3 wins)'
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

def how_many_humans
  players = 0
  loop do
    print 'How many players? (up to 4): '
    players = gets.chomp.to_i
    break if (1..4).cover?(players)
  end
  players
end

def get_player_name(count)
  print "What is player #{count}'s name? "
  gets.chomp
end

def create_players(num_of_humans)
  player_list = {}
  if num_of_humans > 1
    num_of_humans.times do |n|
      player_list[n + 1] = { name: get_player_name(n + 1), token: TOKENS[n],
                             ai: false, score: 0 }
    end
  elsif num_of_humans <= 1
    player_list[1] = { name: get_player_name(1), token: TOKENS[0],
                       ai: false, score: 0 }
    player_list[2] = { name: 'Computer', token: TOKENS[1],
                       ai: true, score: 0 }
  end
  player_list
end

def player_selects_square(board, player, player_list)
  square = ''
  if player[:ai]
    sleep 1
    square = computer_selects_square(board, player_list)
  else
    loop do
      print "#{player[:name]}, please choose a square: "
      square = gets.chomp.to_i
      break if validate_choice(board, square)
      puts 'Sorry, that is not a valid option!'
    end
  end
  mark_square(board, square, player[:token])
end

def computer_selects_square(board, player_list)
  square = computer_selects_aggressive(board, player_list)
  square = computer_selects_defensive(board, player_list) unless square
  square = empty_squares(board, player_list).values.sample unless square
  square
end

def computer_selects_aggressive(board, player_list)
  WINNING_CONDITIONS.each do |line|
    matches_comp = line.count { |sqr| board[sqr] == player_list[2][:token] }
    open_sqrs = line.select { |sqr| board[sqr].class == Integer }.size
    if matches_comp == 2 && open_sqrs == 1
      return line.select { |sqr| board[sqr].class == Integer }[0]
    end
  end
  nil
end

def computer_selects_defensive(board, player_list)
  WINNING_CONDITIONS.each do |line|
    matches_human = line.count { |sqr| board[sqr] == player_list[1][:token] }
    open_sqrs = line.select { |sqr| board[sqr].class == Integer }.size
    if matches_human == 2 && open_sqrs == 1
      return line.select { |sqr| board[sqr].class == Integer }[0]
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

def players_tie?(board, player_list)
  empty_squares(board, player_list).empty?
end

def empty_squares(board, player_list)
  board.select do |_, v|
    v != player_list[1][:token] && v != player_list[2][:token]
  end
end

def player_turns(board, player_list)
  player_list.count.times do |n|
    display_board(board, player_list)
    player_selects_square(board, player_list[n + 1], player_list)
    if winning_player(board, player_list) || players_tie?(board, player_list)
      return 1
    end
  end
  nil
end

def prepare_next_round
  print 'Preparing the next round '
  4.times do
    sleep 1
    print '. '
  end
end

loop do # new game loop
  system 'clear'
  puts 'Welcome to Tic-Tac-Toe!'

  num_of_humans = how_many_humans
  player_list = create_players(num_of_humans)
  round_winner = nil
  board = initialize_board

  loop do # new round loop
    loop do # take turns until someone wins
      break if player_turns(board, player_list)
    end
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
