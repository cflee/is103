# Name: LEE Chiang Fong
# Section: G3

# lab3 (to be done in week 5)
# deadline: 7/Feb/2015 (Sat), 23:59hrs

def select_tweeters(followers)
  result = []
  start_time = Time.now
  result_quality = 0

  # do grouping
  # should end up with an array of arrays (or nil), where each n-th position in
  # main array represents the array of userids that have n followers.
  grouped_users = [];
  followers.each_with_index do |follower_list, userid|
    list = grouped_users[follower_list.length];

    if list.nil?
      list = []
      grouped_users[follower_list.length] = list
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
    # array style
    # obtain a list of ALL followers of the chosen users
    follower_list = []

    # use concat to avoid creating new arrays
    # or having to flatten the array later
    combi.each { |num| follower_list.concat(followers[num]) }

    # remove dupes
    follower_list.uniq!

    # remove the candidate users
    combi.each { |num| follower_list.delete(num) }

    # update tracker variables if necessary
    if follower_list.size > result_quality
      result = combi
      result_quality = follower_list.size
    end

    # if (Time.now - start_time) > 5.985 # 0.25 is the floor
    #   break
    # end
  end

  return result
end
