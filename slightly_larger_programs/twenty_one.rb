require 'pry'

CARD_SUITS = [' HEARTS ', 'DIAMONDS', ' CLUBS  ', ' SPADES '].freeze
CARD_FACES = ['2 ', '3 ', '4 ', '5 ', '6 ', '7 ', '8 ', '9 '] +
             ['10', 'J ', 'Q ', 'K ', 'A '].freeze
ACE = 'A '.freeze

# display methods ==============================================================

# render_cards method accepts an array of hash cards
# hand = [ { suit: " HEARTS ", value: 2, face: "2 " },
#          { suit: "DIAMONDS", value: 10, face: "K "},
#          { suit: " CLUBS  ", value: 1, face: "A " },
#          { suit: " SPADES ", value: 10, face: "10" } ]

def render_cards(hand, hide_first = false)
  card_line_0(hand)
  card_line_1(hand, hide_first)
  card_line_2(hand)
  card_line_3(hand)
  card_line_4(hand, hide_first)
  card_line_5(hand)
  card_line_6(hand)
  card_line_7(hand, hide_first)
  card_line_8(hand)
end

def card_line_0(hand)
  hand.each { print '+----------+ ' }
  puts
end

def card_line_1(hand, hide_first)
  if hide_first
    hand.each_with_index do |card, idx|
      print '| ??       | ' if idx.zero?
      print "| #{card[:face]}       | " if idx >= 1
    end
  else
    hand.each { |card| print "| #{card[:face]}       | " }
  end
  puts
end

def card_line_2(hand)
  hand.each { |_| print '|          | ' }
  puts
end

def card_line_3(hand)
  hand.each { |_| print '|          | ' }
  puts
end

def card_line_4(hand, hide_first)
  if hide_first
    hand.each_with_index do |card, idx|
      print '| ???????? | ' if idx.zero?
      print "| #{card[:suit]} | " if idx >= 1
    end
  else
    hand.each { |card| print "| #{card[:suit]} | " }
  end
  puts
end

def card_line_5(hand)
  hand.each { |_| print '|          | ' }
  puts
end

def card_line_6(hand)
  hand.each { |_| print '|          | ' }
  puts
end

def card_line_7(hand, hide_first)
  if hide_first
    hand.each_with_index do |card, idx|
      print '|       ?? | ' if idx.zero?
      print "|       #{card[:face]} | " if idx >= 1
    end
  else
    hand.each { |card| print "|       #{card[:face]} | " }
  end
  puts
end

def card_line_8(hand)
  hand.each { |_| print '+----------+ ' }
  puts
end

def display_table(players, dealer)
  clear_screen
  puts "Dealer's Hand"
  render_cards(dealer[:hand], true)
  players.each do |player|
    puts
    puts "#{player[:name]}'s Hand"
    render_cards(player[:hand])
  end
end

def clear_screen
  system 'clear'
end

def hold(message)
  puts message
  sleep(3)
end

def welcome
  clear_screen
  puts 'Welcome to 21!'
  puts '--------------'
  puts 'A game for up to 4 players against the dealer.'
  puts
end

def display_winners(players, dealer)
  player_winners = names_of_players_with_21(players)
  if any_player_has_21?(players) && dealer_has_21?(dealer)
    puts "#{player_winners} tied with the dealer!"
  elsif any_player_has_21?(players) && !dealer_has_21?(dealer)
    puts "#{player_winners} beat the dealer!"
  else
    puts 'Nobody won...'
  end
end

def names_of_players_with_21(players)
  winners = ''
  players_with_21(players).each do |player|
    winners << if winners.size.zero?
                 player[:name]
               else
                 " and #{player[:name]}"
               end
  end
  winners
end

def play_again?
  choice = false
  loop do
    print 'Would you like to play another round? (y/n): '
    choice = gets.chomp.downcase
    break if %w(y yes n no).include?(choice)
    puts 'Sorry, that is not a valid option...'
  end
  %w(y yes).include?(choice) ? true : false
end

# game methods =================================================================

def initialize_deck(num_of_decks)
  deck = build_deck(num_of_decks)
  shuffle_deck(deck)
end

def ask_num_of_decks
  num_of_decks = 0
  loop do
    print 'How many decks would you like to play with? (4 maximum): '
    num_of_decks = gets.chomp.to_i
    break if (1..4).cover?(num_of_decks)
    puts 'Sorry, that is not a valid option...'
  end
  num_of_decks
end

def build_deck(num_of_decks)
  deck = []
  CARD_SUITS.each do |suit|
    CARD_FACES.each do |face|
      value = 10 if face.to_i.zero?
      value = face.to_i if (2..10).cover?(face.to_i)
      value = 11 if face == ACE
      deck << { suit: suit, value: value, face: face }
    end
  end
  deck * num_of_decks
end

def shuffle_deck(deck)
  10.times { deck.shuffle! }
  deck
end

def initialize_players(num_of_players)
  players = []
  num_of_players.times { |n| players << create_player(n + 1) }
  players
end

def ask_num_of_players
  num_of_players = 0
  loop do
    print 'How many players? (4 maximum): '
    num_of_players = gets.chomp.to_i
    break if (1..4).cover?(num_of_players)
    puts 'Sorry, that is not a valid option...'
  end
  num_of_players
end

def create_player(player_position)
  name = ask_player_name(player_position)
  { name: name, hand: [] }
end

def ask_player_name(player_position)
  name = ''
  loop do
    print "What is player #{player_position}'s name? "
    name = gets.chomp
    break if name.size >= 3 && !name.include?(' ')
    puts 'Sorry, please enter a name with'
    puts 'at least 3 characters and no spaces...'
  end
  name
end

def initialize_dealer
  { name: 'Dealer', hand: [] }
end

def deal_first_hand(deck, players, dealer)
  players.each do |player|
    2.times { deal_card(deck, player) }
  end
  2.times { deal_card(deck, dealer) }
end

def deal_card(deck, player)
  player[:hand] << deck.shift
end

def hand_value(hand)
  aces = num_aces_in_hand(hand)
  hand_value = hand.sum { |card| card[:value] }
  adjust_value_for_aces(hand_value, aces)
end

def adjust_value_for_aces(hand_value, aces)
  if hand_value > 21 && aces > 0
    adjust_value_for_aces(hand_value - 10, aces - 1)
  else
    hand_value
  end
end

def num_aces_in_hand(hand)
  hand.count { |card| card[:face] == ACE }
end

def equals_21?(hand)
  hand_value(hand) == 21
end

def less_than_17(hand)
  hand_value(hand) < 17
end

def busted?(hand)
  hand_value(hand) > 21
end

def any_player_has_21?(players)
  return true if players.any? { |player| equals_21?(player[:hand]) }
  false
end

def players_with_21(players)
  players.select { |player| equals_21?(player[:hand]) }
end

def dealer_has_21?(dealer)
  equals_21?(dealer[:hand])
end

def player_turns(deck, players, dealer)
  players.each { |player| player_turn(deck, players, player, dealer) }
end

def player_turn(deck, players, player, dealer)
  while player_hits?(player)
    deal_card(deck, player)
    display_table(players, dealer)
    if busted?(player[:hand])
      hold('Sorry, you busted!')
      break
    end
  end
end

def player_hits?(player)
  choice = false
  loop do
    print "#{player[:name]}, would you like to hit or stay? "
    choice = gets.chomp.downcase
    break if %w(hit stay).include?(choice)
    puts 'Sorry, that is not a valid option...'
  end
  choice == 'hit' ? true : false
end

loop do # main game loop
  welcome
  num_of_players = ask_num_of_players
  players = initialize_players(num_of_players)
  dealer = initialize_dealer
  num_of_decks = ask_num_of_decks

  loop do # single round loop
    deck = initialize_deck(num_of_decks)
    deal_first_hand(deck, players, dealer)
    display_table(players, dealer)

    break if any_player_has_21?(players)

    player_turns(deck, players, dealer)
    # dealer_turn(dealer)

    break
  end

  display_winners(players, dealer)
  break unless play_again?
end
