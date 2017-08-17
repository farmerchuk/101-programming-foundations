# Mortgage Calculator --
# This application takes 3 pieces of information
# from the user: the loan amount, the Annual
# Percentage Rate and the loan duration, then
# returns the monthly payment.

require 'yaml'

MESSAGES = YAML.load_file('mortgage_calculator_messages.yml')

def format_number(num)
  format('%.2f', num.to_s)
end

def number?(num)
  num.to_i > 0 &&
  num.to_i.to_s == num || num.to_f.to_s == num
end

# start of main program

puts MESSAGES["title"]
puts MESSAGES["divider"]

loop do
  principal = ""
  loop do
    print "Please enter the loan amount: "
    principal = gets.chomp
    break if number?(principal)
    puts MESSAGES['invalid_number']
  end

  annual_interest_rate = ""
  loop do
    print "Please enter the Annual Percentage Rate (ex. 2.75): "
    annual_interest_rate = gets.chomp
    break if number?(annual_interest_rate)
    puts MESSAGES['invalid_number']
  end

  duration_in_months = ""
  loop do
    print "Please enter the loan duration (months): "
    duration_in_months = gets.chomp
    break if number?(duration_in_months)
    puts MESSAGES['invalid_number']
  end

  monthly_interest_rate = annual_interest_rate.to_f / 12 / 100
  monthly_payment = principal.to_f *
                    (monthly_interest_rate /
                    (1 - (1 + monthly_interest_rate)**
                    (-duration_in_months.to_i)))

  puts "Your monthly payment is: $#{format_number(monthly_payment)}"
  print "Would you like to calculate another monthly payment? (y/n): "
  user_response = gets.chomp
  break if user_response[0] != 'y'
end

puts "Goodbye!"
