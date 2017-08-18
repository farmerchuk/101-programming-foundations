# A simple game of rock-paper-scissors.

CHOICES = %w(rock paper scissors)

# main program loop start

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
  case
  when player_choice == computer_choice
    puts "It's a tie!"
  when (player_choice == "rock" && computer_choice == "scissors") ||
       (player_choice == "paper" && computer_choice == "rock") ||
       (player_choice == "scissors" && computer_choice == "paper")
    puts "Player wins!"
  else
    puts "Computer wins!"
  end

  puts "Would you like to play again? (y/n)"
  player_input = gets.chomp
  break if player_input.downcase[0] != "y"

end

# game ends
puts "Thanks for playing!"
