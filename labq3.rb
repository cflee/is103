# Name: LEE Chiang Fong
# Section: G3

# lab3 (to be done in week 5)
# deadline: 7/Feb/2015 (Sat), 23:59hrs

def select_tweeters(followers)
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

  # determine top-n users to inspect
  top_n = sqrt(top_users.length)
  top_n = top_users.length / 5 if top_n < 7   # 20%
  top_n = top_users.length / 2 if top_n < 7   # 50%
  top_n = top_users.length if top_n < 7       # 100%
  # top_n = 34
  top_users[0..top_n].combination(5) do |combi|
    count += 1


    # array style
    # obtain a list of ALL followers of the chosen users
    follower_list = []
    combi.each do |num|
      # use concat to avoid creating new arrays
      # or having to flatten the array later
      follower_list.concat(followers[num])
    end

    # remove dupes
    follower_list.uniq!

    # remove the candidate users
    combi.each do |num|
      follower_list.delete(num)
    end

    # p combi
    # puts "Size=" + follower_list.size.to_s + ", current result size=" + result_quality.to_s
    # puts

    # update tracker variables if necessary
    if follower_list.size > result_quality
      result = combi
      result_quality = follower_list.size
    end

    # if (Time.now - start_time) > 5.985 # 0.25
    #   break
    # end
  end

  # puts "Count = " + count.to_s

  return result
end
