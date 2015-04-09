# same as p2q3.rb but shortened and slightly more idiomatic
def plan_tour(adj_matrix, node_value, node_time, origin, dest, time_limit)
  n = adj_matrix.size
  node_value[dest] = 0

  # impute node_time into adj_matrix
  (0...n).each do |s|
    (s+1...n).each do |d|
      # ignore if no edge exists between s and d
      if !adj_matrix[s][d].nil?
        # compute new cost
        # don't include s/d if it's the origin/dest node
        new_cost = adj_matrix[s][d].to_f
        new_cost += node_time[s] / 2.0 if s != origin && s != dest
        new_cost += node_time[d] / 2.0 if d != origin && d != dest

        # update both directions on the matrix
        adj_matrix[s][d] = new_cost
        adj_matrix[d][s] = new_cost
      end
    end
  end

  # visiting all nodes, consider all neighbours, pick the best (largest value)
  # node that's possible
  stack = []
  stack.push([0, origin, 0, [origin]])

  while !stack.empty?
    value, node, acc_cost, node_path = stack.pop
    return node_path if node == dest

    neighbours = []
    node_path_hash = Hash[node_path.map { |x| [x, nil] }]

    (0...n).each do |d|
      # only visit neighbours that are not already on this path
      # and not out-of-range
      if !adj_matrix[node][d].nil? \
          && !node_path_hash.has_key?(d) \
          && acc_cost + adj_matrix[node][d] <= time_limit
        # this neighbour is feasible!
        neighbours << [node_value[d] / adj_matrix[node][d], d, \
          acc_cost + adj_matrix[node][d], node_path.clone.push(d)]
      end
    end

    # sort by value asc, add to back of stack
    neighbours = neighbours.sort_by { |neighbour| neighbour[0] }
    stack.concat(neighbours)
  end

  return nil
end
