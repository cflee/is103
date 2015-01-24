# convenience utility for double-checking Big-Oh complexity answers
# edit this file first!
#
# inside irb: `load "big-oh.rb"`
# using ruby: `ruby big-oh.rb`

# run test for first few numbers
# take the output and plug into OEIS.org to get the formula!
#
# in OS X Terminal, double-clicking on the comma-separated string will select
# it nicely for Cmd-C ;)
def bigOh
  iterations = 6
  1.upto(iterations) { |n| print methodA(n).to_s + (n != iterations ? "," : "") }
  puts
end

# method to be tested, edit to insert/change loops as necessary
def methodA(n)
  count = 0
  for i in 1..n
    for j in 1..i
      count += f(j)
    end
  end
  return count
end

# model the runtime of a function
# can be a constant (return 1) to measure number of times of execution
# or be proportional to the input parameter j
def f(j)
  return j
end

bigOh
