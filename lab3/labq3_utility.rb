# labq3_utility.rb
# Do not submit this file

# Do not modify this file as well. 
# Ensure that this file is in the same folder as labq3_main.rb

# takes in an array of strings and returns the same array with all the strings converted to integers
# e.g. input: ["3", "4", "8", "-1"]. returns [3, 4, 8, -1]
def convert_array_elements_to_i(array)
  for i in 0..array.length-1
    array[i] = array[i].to_i
  end
end

# reads a CSV file and returns an array of strings - each line in the CSV file as one string
def read_file(file)
	lines = IO.readlines(file)
	if lines != nil
		for i in 0 .. lines.length-1
			lines[i] = lines[i].sub("\n","")
		end
		return lines[0..lines.length-1]
	end
	return nil
end

# takes in 2 arguments:
#   - selected is an array of 5 integers (user IDs)
#   - followers is a 2D array of followers 
# returns an array of unique followers for the 5 selected users in sorted order
def get_unique_followers (selected, followers)
  f0 = followers[selected[0].to_i]
  if (f0 == nil)
    f0 = []
  end 
  f1 = followers[selected[1].to_i]
  if (f1 == nil)
    f1 = []
  end 
  f2 = followers[selected[2].to_i]
  if (f2 == nil)
    f2 = []
  end 
  f3 = followers[selected[3].to_i]
  if (f3 == nil)
    f3 = []
  end 
  f4 = followers[selected[4].to_i]
  if (f4 == nil)
    f4 = []
  end 
  
  f = (f0 + f1 + f2 + f3 + f4).uniq
  # remove original users (in selected)
  f.delete(selected[0].to_i) 
  f.delete(selected[1].to_i)
  f.delete(selected[2].to_i)
  f.delete(selected[3].to_i)
  f.delete(selected[4].to_i)
  return f.sort
end