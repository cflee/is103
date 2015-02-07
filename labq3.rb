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

  # remove followers from consideration. quality = 307, 321.
  0.upto(490) do |offset|
    # don't affect the original since we will delete from this
    candidates = top_users.clone

    # temp storage of the 5 users
    loop_result = []

    # obtain the top 5 users starting from offset
    0.upto(4) do |round|
      userid = candidates[offset + round]
      loop_result << userid

      # remove this user's followers from candidate list
      followers[userid].each do |follower_id|
        candidates.delete(follower_id)
      end
    end

    # calculate quality
    follower_list = []
    loop_result.each { |userid| follower_list.concat(followers[userid]) }
    follower_list.uniq!
    loop_result.each { |userid| follower_list.delete(userid) }

    # update if necessary
    if follower_list.size > result_quality
      result = loop_result
      result_quality = follower_list.size
    end
  end

=begin
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

    # use concat to avoid creating new arrays
    # or having to flatten the array later
    combi.each { |num| follower_list.concat(followers[num]) }

    # remove dupes
    follower_list.uniq!

    # remove the candidate users
    combi.each { |num| follower_list.delete(num) }

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
=end

  return result
end
