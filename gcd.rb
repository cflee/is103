# 02B: Greatest Common Divisor
# requires the `rubylabs` gem for the Source module

# brute force algorithm
#
# :begin :gcd1
def gcd1(a, b)
  t = [a, b].min

  t.downto(1) do |t|
    t # just evaluate the expression so that RubyLabs#count works properly
      # as the next statement isn't counted otherwise
    return t if a % t == 0 && b % t == 0
  end
end
# :end :gcd1

# dijkstra's algorithm
#
# :begin :gcd2
def gcd2(a, b)
  until a == b
    if a > b
      a = a - b
    else
      b = b - a
    end
  end
  a
end
# :end :gcd2

# euclid's algorithm
#
# :begin :gcd3
def gcd3(a, b)
  until b == 0
    t = b
    b = a % b
    a = t
  end
  a
end
# :end :gcd3

Source.clear
Source.probe("gcd1", 5, :count)
Source.probe("gcd2", 3, :count)
Source.probe("gcd3", 3, :count)

def run(a, b)
  [:gcd1, :gcd2, :gcd3].each do |fn|
    puts "#{fn} runs for #{count { self.send(fn, a, b) }} times, taking #{time { self.send(fn, a, b) }.to_s} sec"
  end
end
