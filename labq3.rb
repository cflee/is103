# Name: LEE Chiang Fong
# Section: G3

# lab3 (to be done in week 5)
# deadline: 7/Feb/2015 (Sat), 23:59hrs
require 'set'

def select_tweeters(followers)
  # return [0, 1, 2, 3, 4] # returns a silly solution for now
  result = []
  start_time = Time.now
  count = 0

  result_quality = 0
  # do grouping
  grouped_users = [];
  followers.each_with_index do |follower_list, userid|
    follower_qty = follower_list.length;

    list = grouped_users[follower_qty];
    if list.nil?
      list = []
      grouped_users[follower_qty] = list
    end

    list << userid
  end
  top_users = grouped_users.flatten.compact.reverse

  top_n = sqrt(top_users.length)
  top_n = top_users.length / 5 if top_n < 7   # 20%
  top_n = top_users.length / 2 if top_n < 7   # 50%
  top_n = top_users.length if top_n < 7       # 100%
  # top_n = 34
  top_users[0..top_n].combination(5) do |combi|
    count += 1

    s = Set.new
    combi.each do |num|
      s.merge(followers[num])
    end
    s.subtract(combi)

    # p combi
    # puts "Size=" + s.size.to_s + ", current result size=" + result_quality.to_s
    # puts

    if s.size > result_quality
      result = combi
      result_quality = s.size
    end

    if (Time.now - start_time) > 0.35
      break
    end
  end


=begin
  # naive brute force until 1.0 sec == 232 quality
  count = 0
  Array(0..followers.length-1).combination(5) do |combination|
    count += 1

    s = Set.new
    combination.each do |num|
      s.merge(followers[num])
    end
    s.subtract(combination)

    if s.size > result.length
      result = combination
      # puts "Size=" + s.size.to_s + ", " + result.to_s
    end

    if (Time.now - start_time) > 5.985
      break
    end
  end
  # puts "Total iterations: " + count.to_s
=end

=begin
  # random users
  result = []
  1.upto(5) do
    result << rand(followers.length)
  end


=begin
  # users with top 5 number of followers
  result = []

  # do grouping
  grouped_by_follower_qty = [];
  followers.each_with_index do |followers, userid|
    follower_qty = followers.length;

    hash = grouped_by_follower_qty[follower_qty];
    if hash == nil
      hash = {}
      grouped_by_follower_qty[follower_qty] = hash
    end

    hash[userid] = followers
  end

  # extract results
  grouped_by_follower_qty.reverse_each do |hash|
    hash.each do |userid, followers|
      result << userid unless result.length > 4
    end unless hash.nil?
  end
=end

  return result
end
