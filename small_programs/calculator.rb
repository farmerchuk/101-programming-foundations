# as the user for two numbers
# ask the user for an operation to perform
# perform the operation on the two numbers
# output the result

puts "Welcome to Calculator!"

print "Please enter a number: "
num1 = gets.chomp.to_i
print "Please enter a second number: "
num2 = gets.chomp.to_i
print "Please enter a operation (+)(-)(*)(/): "
operator = gets.chomp

print "Calculating."
3.times do
  sleep 1
  print "."
end

case operator
when "+" then result = num1 + num2
when "-" then result = num1 - num2
when "*" then result = num1 * num2
when "/" then result = num1.to_f / num2
else result = nil
end

if result.nil?
  abort "Sorry, but '#{operator}' is not a valid operator!"
end

puts "The answer is: #{result}"
