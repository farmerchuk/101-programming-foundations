require 'pry'

CARD_SUITS = [' HEARTS ', 'DIAMONDS', ' CLUBS  ', ' SPADES '].freeze
CARD_FACES = ['2 ', '3 ', '4 ', '5 ', '6 ', '7 ', '8 ', '9 '] +
             ['10', 'J ', 'Q ', 'K ', 'A '].freeze
ACE = 'A'.freeze

# card rendering methods =======================================================

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
  system 'clear'
  puts "Dealer's Hand"
  render_cards(dealer[:hand], true)
  players.each do |player|
    puts
    puts "#{player[:name]}'s Hand"
    render_cards(player[:hand])
  end
end

# game methods =================================================================

def clear_screen
  system 'clear'
end

def welcome
  puts 'Welcome to 21!'
  puts '--------------'
  puts 'A game for up to 4 players against the dealer.'
  puts
end

def initialize_deck
  num_of_decks = ask_num_of_decks
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
      value = 11 if face.rstrip == ACE
      deck << { suit: suit, value: value, face: face }
    end
  end
  deck * num_of_decks
end

def shuffle_deck(deck)
  10.times { deck.shuffle! }
  deck
end

def initialize_players
  players = []
  num_of_players = ask_num_of_players
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

def player_hits_or_stays
  choice = ''
  loop do
    print 'Would you like to hit or stay? '
    choice = gets.chomp.downcase
    break if %w(hit stay).include?(choice)
    puts 'Sorry, that is not a valid option...'
  end
  choice.to_s
end

# game loop

welcome

players = initialize_players
dealer = initialize_dealer
deck = initialize_deck

deal_first_hand(deck, players, dealer)
display_table(players, dealer)
