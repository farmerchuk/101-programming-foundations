# write in pseudocode a method that
# returns the sum of two integers

=begin
- ask and retrieve the first number from the user
- ask and retrieve the second number from the user
- confirm the user inputs are indeed integers
- calculate the sum of the two integers
- print the result
=end

BEGIN
  PRINT "Please enter the first number:"
  GET num1
  PRINT "Please enter the second number:"
  GET num 2
  IF num1 && num 2 are indeed integers
    result = num1 + num2
    PRINT result
  ELSE
    "Please enter valid numbers!"
END


# write in pseudocode a method that
# takes an array of integers and returns
# a new array with every other element

=begin
- receive an array of integers
- loop through the array, adding every other
element to a new array
- return the new array
=end

BEGIN
  GET array
  SET iterator = 0
  WHILE iterator < array.size
    IF array[element].odd?
      new_array << array[element]
    iterator += 1
  RETURN array
END
