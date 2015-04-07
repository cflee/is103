def select_actors(k, r, movie_list)
  @start_time = Time.now
  @timeout = 50.0 # seconds

  # turn the movie list into an actor hash of arrays
  actors = {}
  for m in movie_list do
    for a in m[2] do
      actors[a] = [] if !actors.has_key?(a)
      actors[a] << m
    end
  end
  # convert hash into array, sorted by number of movies desc
  actor_list = actors.sort_by { |l, v| -v.length }

  if r == 1
    # choose greedy algo when r=1
    # saves time!
    n = 25
    n = k + 5 if k > n
    n = actor_list.length - 1 if n > actor_list.length # cap at list length
    result = select_actors_greedy(k, r, n, actor_list)
  else
    # choose brute force algo otherwise
    n = 25
    n = k + 5 if k > n
    n = actor_list.length - 1 if n > actor_list.length
    result = select_actors_combi(k, r, n, actor_list)
  end

  return result
end

# n is top n actors to consider (0 to n inclusive)
def select_actors_combi(k, r, n, actor_list)
  result = []
  result_q = 0

  # process all k-combinations of top-(n+1) actors until timeout
  actor_list[0..n].combination(k) do |actors|
    break if (Time.now - @start_time) > @timeout

    # accumulate the number of chosen-actors in each movie
    c_movies = Hash.new(0)
    for actor in actors do
      mm = actor[1]
      for movie in mm do
        c_movies[movie.object_id] += 1
      end
    end

    # determine the quality of this combination
    # i.e. how many movies with at least r chosen-actors
    c_movies_score = 0
    for v in c_movies.values do
      c_movies_score += 1 if v >= r
    end

    # replace if better than previous solution
    if c_movies_score > result_q
      result = actors
      result_q = c_movies_score
    end
  end

  # convert actor arrays to actor names
  return result.map { |a| a[0] }
end

# n is top n actors to consider (0 to n inclusive)
def select_actors_greedy(k, r, n, actor_list)
  # pick the actor with the most movies as first actor
  result_a = [0]
  result_m = actor_list[0][1].clone
  result_q = result_m.length

  # store the indexes of actors that are still being considered
  actor_indexes = Array(1..n)

  # pick the remaining k-1 actors (since 1st has been picked)
  1.upto(k-1) do |i|
    best_index = actor_indexes[0] # first actor still being considered
    best_q = result_q
    best_m = result_m.clone

    # examine all the actors still being considered
    for index in actor_indexes do
      # optimisation
      # don't go on if the remaining actors are too small to improve on
      # the currently found best quality
      break if result_q + actor_list[index][1].length < best_q

      # get all the movies that the actors are in (without duplicates)
      c_movies = best_m.clone | actor_list[index][1]

      # replace if better than previous solution
      if c_movies.length > best_q
        best_index = index
        best_q = c_movies.length
        best_m = c_movies
      end
    end

    # take the best found solution
    result_a << best_index
    result_q = best_q
    result_m = best_m
    actor_indexes.delete(best_index)
  end

  # convert actor ID to actor names
  return result_a.map { |i| actor_list[i][0] }
end
