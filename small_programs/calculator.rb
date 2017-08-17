# as the user for two numbers
# ask the user for an operation to perform
# perform the operation on the two numbers
# output the result

require 'yaml'

MESSAGES = YAML.load_file 'calculator_messages.yml'

LANGUAGE = 'fr'

OPERATORS = { "+" => "Adding",
              "-" => "Subtracting",
              "*" => "Multiplying",
              "/" => "Dividing" }

OPERATOR_PROMPT = <<-MSG
Please enter an operator:
  (+) Add
  (-) Subtract
  (*) Multiply
  (/) Divide
MSG

def message(msg, lang='en')
  MESSAGES[lang][msg]
end

def puts_(message)
  puts "> #{message}"
end

def print_(message)
  print "> #{message}"
end

def valid_number(num)
  num.to_i.to_s == num || num.to_f.to_s == num
end

def get_number
  num = ""
  loop do
    print_ "Please enter a number: "
    num = gets.chomp
    break if valid_number(num)
    puts_ message 'invalid_number', LANGUAGE
  end
  num.to_f
end

# main program start

  puts_ message 'welcome', LANGUAGE

# main program loop start

loop do

  num1 = get_number
  num2 = get_number

  operator = ""
  loop do
    print_ OPERATOR_PROMPT
    operator = gets.chomp
    break if OPERATORS.key? operator
    puts_ message 'invalid_operator', LANGUAGE
  end

  case operator
  when "+" then result = num1 + num2
  when "-" then result = num1 - num2
  when "*" then result = num1 * num2
  when "/" then result = num1.to_f / num2
  end

  print_ "#{OPERATORS[operator]} #{num1} and #{num2}"
  3.times do
    print "."
    sleep 1
  end

  puts "The answer is: #{result}"

  print_ message 'run_again', LANGUAGE
  user_choice = gets.chomp
  break if user_choice[0].downcase != "y"
end

puts_ message 'goodbye', LANGUAGE
