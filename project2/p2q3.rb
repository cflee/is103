# p2q3.rb as submitted
def plan_tour(adj_matrix, node_value, node_time, origin, dest, time_limit)
  # number of nodes in the graph
  n = adj_matrix.size
  result = nil
  node_value[dest] = 0

  # impute node_time into adj_matrix, by attributing half the node time
  # to the edges surrounding each node.
  # in other words, each edge time should factor in half the node time from
  # each endpoint, unless it's the origin/dest node, because they aren't visited
  #
  # iterate over the combinations
  # e.g. for n=5, 01 02 03 04 05 12 13 14 15 23 24 25 34 35 45
  for s in 0...n
    line = adj_matrix[s]
    for d in (s+1)...n
      # ignore if no edge exists between s and d
      if !line[d].nil?
        # compute new cost
        # don't include s/d if it's the origin/dest node
        new_cost = line[d].to_f
        if s != origin && s != dest
          new_cost += node_time[s] / 2.0
        end
        if d != origin && d != dest
          new_cost += node_time[d] / 2.0
        end

        # update both directions on the matrix
        adj_matrix[s][d] = new_cost
        adj_matrix[d][s] = new_cost
      end
    end
  end

  # visiting all nodes, consider all neighbours, pick the best (largest value)
  # node that's possible. impossible nodes are ones that are either already on
  # the traversed path, or ones that are definitely out-of-range from dest.
  #
  # nodes are definitely out-of-range if the accumulated travel time so far,
  # plus edge travel time to the node, exceeds the time limit.
  stack = [[0, origin, 0, [origin]]]

  while !stack.empty?
    value, node, acc_cost, node_path = stack.pop

    if node == dest
      result = node_path
      break
    end

    node_path_hash = Hash[node_path.map { |x| [x, nil] }]

    neighbours = []
    # examine all neighbours, collect those that are feasible
    line = adj_matrix[node]
    for d in 0...n
      if !line[d].nil?
        # only visit neighbours that are not already on this path
        if !node_path_hash.has_key?(d)
          # only visit neighbours that are not out-of-range
          if acc_cost + line[d] <= time_limit
            # this neighbour is feasible!
            neighbours << [node_value[d] / line[d], d, acc_cost + line[d], node_path.clone.push(d)]
          end
        end
      end
    end

    # sort by value asc, add to back of stack
    neighbours = neighbours.sort_by { |neighbour| neighbour[0] }
    stack.concat(neighbours)
  end

  return result
end

=begin
Note that this implementation doesn't handle origin == dest case properly!

Change the following lines to fix it:
42: stack = [[0, origin, 0, []]]
47: if node_path.size > 0 && node == dest
75: return result.unshift(origin)

=end
