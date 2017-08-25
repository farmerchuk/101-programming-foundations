require 'pry'

CARD_SUITS = [' HEARTS ', 'DIAMONDS', ' CLUBS  ', ' SPADES '].freeze
CARD_FACES = ['2 ', '3 ', '4 ', '5 ', '6 ', '7 ', '8 ', '9 '] +
             ['10', 'J ', 'Q ', 'K ', 'A '].freeze

# card rendering methods =======================================================

# render_cards method accepts an array of hash cards
# hand = [ { suit: " HEARTS ", value: 2, face: "2 " },
#          { suit: "DIAMONDS", value: 10, face: "K "},
#          { suit: " CLUBS  ", value: 1, face: "A " },
#          { suit: " SPADES ", value: 10, face: "10" } ]

def render_cards(hand)
  card_line_0(hand)
  card_line_1(hand)
  card_line_2(hand)
  card_line_3(hand)
  card_line_4(hand)
  card_line_5(hand)
  card_line_6(hand)
  card_line_7(hand)
  card_line_8(hand)
end

def card_line_0(hand)
  hand.each { print "+----------+ " }
  puts
end

def card_line_1(hand)
  hand.each { |card| print "| #{card[:face]}       | " }
  puts
end

def card_line_2(hand)
  hand.each { |card| print "|          | " }
  puts
end

def card_line_3(hand)
  hand.each { |card| print "|          | " }
  puts
end

def card_line_4(hand)
  hand.each { |card| print "| #{card[:suit]} | " }
  puts
end

def card_line_5(hand)
  hand.each { |card| print "|          | " }
  puts
end

def card_line_6(hand)
  hand.each { |card| print "|          | " }
  puts
end

def card_line_7(hand)
  hand.each { |card| print "|       #{card[:face]} | " }
  puts
end

def card_line_8(hand)
  hand.each { |card| print "+----------+ " }
  puts
end

def display_table(players, dealer)
  system 'clear'
  puts "Dealer's Hand"
  render_cards(dealer[:hand])
  players.each do |player|
    puts # spacing
    puts "#{player[:name]}'s Hand"
    render_cards(player[:hand])
  end
end

# game methods =================================================================

def welcome
  puts "Welcome to 21!"
  puts "--------------"
  puts "A game for up to 4 players against the dealer."
  puts # spacing
end

def initialize_deck
  deck = build_deck
  shuffle_deck(deck)
end

def build_deck
  deck = []
  CARD_SUITS.each do |suit|
    CARD_FACES.each do |face|
      case face.to_i
      when 0 then value = 10
      when (2..10) then value = face.to_i
      end
      value = 1 if face.rstrip == "A"
      deck << { suit: suit, value: value, face: face }
    end
  end
  deck
end

def shuffle_deck(deck)
  10.times { deck.shuffle! }
  deck
end

def initialize_players
  players = []
  num_of_players = ask_num_of_players
  num_of_players.times { |n| players << create_player(n + 1)}
  players
end

def ask_num_of_players
  num_of_players = 0
  loop do
    print 'How many players? (4 maximum): '
    num_of_players = gets.chomp.to_i
    break if (1..4).include?(num_of_players)
    puts 'Sorry, that is not a valid option...'
  end
  num_of_players
end

def create_player(player_position)
  name = ask_player_name(player_position)
  { name: name, hand: [] }
end

def ask_player_name(player_position)
  print "What is player #{player_position}'s name: "
  gets.chomp
end

def initialize_dealer
  { name: "Dealer", hand: [] }
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

# game loop

welcome

deck = initialize_deck
players = initialize_players
dealer = initialize_dealer

deal_first_hand(deck, players, dealer)
display_table(players, dealer)
