# labq3_main.rb
# Do not submit this file

# You may modify this file for testing purposes, 
# but your final labq3.rb must be able to run with the original labq3_main.rb.

load "labq3.rb"
load "labq3_utility.rb"
include Math

# get name of CSV file from keyboard
if ARGV.length > 0
  file_name = ARGV[0]
else
  puts
  print "Enter name of CSV file in data folder to read from (e.g. t1.csv) :"
  file_name = gets.chomp
end

# read from file_name and store in input
input = []
read_file("data/"+file_name).each{ |line|
  array = line.split(",").map(&:strip)
  convert_array_elements_to_i(array)
  
  source_id = array.shift # the 1st element is the user ID of a tweeter 
  direct_followers = array # the remaining elements will be the followers of source_id
  
  input[source_id] = direct_followers
}

# uncomment the following statement if desired
# puts "Read the following data from " + file_name + ":" + input.inspect
puts 

# run the test case
puts "Starting now..."
startTime = Time.now
selected = select_tweeters(input)
puts "Execution time #{Time.now - startTime} seconds." # display time lapsed
puts 

# check for errors in selected
if (selected == nil)
  # error
  puts "Error : your method returned nil. It should return an array of 3 integers."
elsif (!selected.kind_of?(Array))
  # error
  puts "Error : your method returned something other than an array. It should return an array of 3 integers."
elsif (selected.length!=5)
  # error
  puts "Error : your method returned an array of fewer than, or more than 5 elements. It should return an array of exactly 5 integers."
else 
  # no errors - check and print out quality of answer
  unique_followers = get_unique_followers(selected, input)
  
  # uncomment the following statements if desired  
  # puts "Your 1st selected user " + selected[0].to_s + " has the following followers :" + input[selected[0].to_i].inspect
  # puts "Your 2nd selected user " + selected[1].to_s + " has the following followers :" + input[selected[1].to_i].inspect
  # puts "Your 3rd selected user " + selected[2].to_s + " has the following followers :" + input[selected[2].to_i].inspect
  # puts "Your 4th selected user " + selected[3].to_s + " has the following followers :" + input[selected[3].to_i].inspect
  # puts "Your 5th selected user " + selected[4].to_s + " has the following followers :" + input[selected[4].to_i].inspect    
  # puts "Your solution returned the following unique followers :" + unique_followers.inspect
  
  puts "Quality Score (number of unique followers) for this data set :" + unique_followers.length.to_s
end
