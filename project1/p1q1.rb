def create_actor_list(movie_list)
  # sort by movie name asc
  # group by year
  # get the grouped-by-year arrays in year desc
  years = movie_list.sort_by { |m| m[0] }.group_by { |x| x[1] }.sort_by { |k, v| -k }

  # accumulate in arrays per actor
  actors = {}
  for y in years do # y[0] = year, y[1] = list of movie objects
    for m in y[1] do # m[0] = movie name, m[1] = year, m[2] = list of actor names
      for a in m[2] do # a = actor name
        actors[a] = [] if !actors.has_key?(a)
        actors[a] << m[0]
      end
    end
  end

  # obtain accumulated arrays in actor name asc
  return actors.sort_by { |k, v| k }
end
