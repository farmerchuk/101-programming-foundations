# A simple game of rock-paper-scissors-lizard-spock.

CHOICES = %w(rock paper scissors lizard spock)
LOSING_CONDITIONS = { rock: %w(lizard scissors),
                      paper: %w(rock spock),
                      scissors: %w(paper lizard),
                      lizard: %(spock paper),
                      spock: %(scissors rock) }
player_score = 0
computer_score = 0

# main game loop start
loop do
  # player selects an option
  player_choice = ""
  loop do
    puts "Options: #{CHOICES.join(', ')}"
    print "Please choose one of the above: "
    player_choice = gets.chomp
    break if CHOICES.include?(player_choice)
    puts "Not a valid option! Try again..."
  end

  # computer selects an option
  computer_choice = CHOICES.sample
  puts "The computer chose #{computer_choice}..."

  # determine winner
  if player_choice == computer_choice
    puts "It's a tie!"
  elsif (player_choice == "rock" &&
          LOSING_CONDITIONS[:rock].include?(computer_choice)) ||
        (player_choice == "paper" &&
          LOSING_CONDITIONS[:paper].include?(computer_choice)) ||
        (player_choice == "scissors" &&
          LOSING_CONDITIONS[:scissors].include?(computer_choice)) ||
        (player_choice == "lizard" &&
          LOSING_CONDITIONS[:lizard].include?(computer_choice)) ||
        (player_choice == "spock" &&
          LOSING_CONDITIONS[:spock].include?(computer_choice))
    player_score += 1
    puts "Player wins the round!"
  else
    computer_score += 1
    puts "Computer wins the round!"
  end

  # test for winner, play again?
  if player_score == 5 || computer_score == 5
    if player_score == 5
      puts "You win the game!!!"
    else
      puts "The computer wins!"
    end
    puts "Would you like to play again? (y/n)"
    player_input = gets.chomp
    break if player_input.downcase[0] != "y"
    player_score = 0
    computer_score = 0
  end
end

# game ends
puts "Thanks for playing!"
