CARD_SUITS = [' HEARTS ', 'DIAMONDS', ' CLUBS  ', ' SPADES '].freeze
CARD_FACES = ['2 ', '3 ', '4 ', '5 ', '6 ', '7 ', '8 ', '9 '] +
             ['10', 'J ', 'Q ', 'K ', 'A '].freeze
ACE = 'A '.freeze
MAX_SCORE = 21
DEALER_STAY = 17

def render_cards(hand, hide_first)
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

def display_table(players, dealer, hide_first = true)
  clear_screen
  puts "Dealer's Hand"
  render_cards(dealer[:hand], hide_first)
  players.each do |player|
    puts
    puts "#{player[:name]}'s Hand"
    render_cards(player[:hand], false)
  end
  puts
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
  puts '------------------------------------------------------'
  puts 'A card game for up to 4 players against the dealer.'
  puts '(Suggested screen size of 62 lines for 3 or 4 players)'
  puts
end

# rubocop:disable Metrics/AbcSize
def display_winners(players, dealer)
  if all_players_busted?(players) && players.size > 1
    puts 'All players busted. Dealer wins!'
  elsif dealer_has_best_hand?(players, dealer) && players.size > 1
    puts "Dealer beats everyone with #{hand_value(dealer[:hand])}!"
  else
    puts dealer_result(players, dealer)
    players.each do |player|
      puts player_result(player, dealer)
    end
  end
end
# rubocop:enable Metrics/AbcSize

def dealer_result(players, dealer)
  result = 'loses'
  if busted?(dealer[:hand])
    result = 'busts'
  elsif all_players_busted?(players) || dealer_has_best_hand?(players, dealer)
    result = 'wins'
  elsif dealer_ties_any_player?(players, dealer) &&
        players_who_beat_dealer(players, dealer).empty?
    result = 'ties'
  end
  "Dealer #{result} with #{hand_value(dealer[:hand])}"
end

# rubocop:disable Metrics/MethodLength
def player_result(player, dealer)
  player_hand_value = hand_value(player[:hand])
  dealer_hand_value = hand_value(dealer[:hand])
  if busted?(player[:hand])
    result = 'busts'
  elsif player_hand_value > dealer_hand_value || busted?(dealer[:hand])
    result = 'wins against the dealer'
  elsif player_hand_value < dealer_hand_value
    result = 'loses against the dealer'
  elsif player_hand_value == dealer_hand_value
    result = 'ties the dealer'
  end
  "#{player[:name]} #{result} with #{player_hand_value}"
end
# rubocop:enable Metrics/MethodLength

def play_again?
  choice = ''
  loop do
    print 'Would you like to play another round? (y/n): '
    choice = gets.chomp.downcase
    break if %w(y yes n no).include?(choice)
    puts 'Sorry, that is not a valid option...'
  end
  return true if %w(y yes).include?(choice)
  false
end

def game_over
  puts
  puts 'Thank you for playing 21!'
end

def initialize_deck(num_of_decks)
  deck = build_deck(num_of_decks)
  shuffle_deck(deck)
end

def ask_num_of_decks
  num_of_decks = ''
  loop do
    print 'How many decks would you like to play with? (4 maximum): '
    num_of_decks = gets.chomp
    break if %w(1 2 3 4).include?(num_of_decks)
    puts 'Sorry, that is not a valid option...'
  end
  num_of_decks.to_i
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
  num_of_players = ''
  loop do
    print 'How many players? (4 maximum): '
    num_of_players = gets.chomp
    break if %w(1 2 3 4).include?(num_of_players)
    puts 'Sorry, that is not a valid option...'
  end
  num_of_players.to_i
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
  if hand_value > MAX_SCORE && aces > 0
    adjust_value_for_aces(hand_value - 10, aces - 1)
  else
    hand_value
  end
end

def num_aces_in_hand(hand)
  hand.count { |card| card[:face] == ACE }
end

def equals_21?(hand)
  hand_value(hand) == MAX_SCORE
end

def less_than_17?(hand)
  hand_value(hand) < DEALER_STAY
end

def busted?(hand)
  hand_value(hand) > MAX_SCORE
end

def all_players_busted?(players)
  return true if players.all? { |player| busted?(player[:hand]) }
end

def dealer_busted?(dealer)
  busted?(dealer[:hand])
end

def players_who_beat_dealer(players, dealer)
  not_busted = players.select { |player| !busted?(player[:hand]) }
  not_busted.select do |player|
    hand_value(player[:hand]) > hand_value(dealer[:hand])
  end
end

def dealer_has_best_hand?(players, dealer)
  return false if busted?(dealer[:hand])
  return true if all_players_busted?(players)
  player = player_with_best_hand(players)
  hand_value(dealer[:hand]) > hand_value(player[:hand])
end

def dealer_ties_any_player?(players, dealer)
  return false if dealer_busted?(dealer)
  players.any? do |player|
    hand_value(player[:hand]) == hand_value(dealer[:hand])
  end
end

def player_with_best_hand(players)
  players_not_busted = players.select { |player| !busted?(player[:hand]) }
  players_not_busted.sort_by { |player| hand_value(player[:hand]) }.last
end

def player_turns(deck, players, dealer)
  players.each do |player|
    player_turn(deck, players, player, dealer)
    display_table(players, dealer)
  end
end

def player_turn(deck, players, player, dealer)
  while player_hits?(player)
    deal_card(deck, player)
    display_table(players, dealer)
    if busted?(player[:hand])
      hold("Sorry #{player[:name]}, you busted!")
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

def dealer_turn(deck, players, dealer)
  while less_than_17?(dealer[:hand]) && !all_players_busted?(players)
    display_table(players, dealer)
    hold('Dealer is drawing cards...')
    deal_card(deck, dealer)
  end
end

def new_round?(players, dealer)
  puts
  choice = false
  if play_again?
    clear_screen
    reset_dealer_hand(dealer)
    reset_player_hands(players)
    choice = true
  end
  choice
end

def reset_player_hands(players)
  players.each { |player| player[:hand] = [] }
end

def reset_dealer_hand(dealer)
  dealer[:hand] = []
end

welcome
num_of_players = ask_num_of_players
players = initialize_players(num_of_players)
num_of_decks = ask_num_of_decks
deck = initialize_deck(num_of_decks)
dealer = initialize_dealer

loop do
  deck = initialize_deck(num_of_decks)
  deal_first_hand(deck, players, dealer)
  display_table(players, dealer)
  player_turns(deck, players, dealer)
  dealer_turn(deck, players, dealer)
  display_table(players, dealer, false)
  display_winners(players, dealer)
  break unless new_round?(players, dealer)
end

game_over
