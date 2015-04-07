# a more interesting implementation
#
# - node touring times are imputed into edge travel times
# - dijkstra from dest to find shortest feasible path from all nodes
# - considering the max value/time heuristic when selecting which neighbour
#   to visit next, by examining the neighbour's neighbours
def plan_tour(adj_matrix, node_value, node_time, origin, dest, time_limit)
  # number of nodes in the graph
  n = adj_matrix.size
  result = nil

  # reset the destination node value to 0
  node_value[dest] = 0

  # impute node_time into adj_matrix
  adjust_matrix(adj_matrix, node_time, origin, dest)

  # run dijkstra's from Q2 to obtain shortest distances to all nodes from the
  # destination
  dest_dist = find_way_all(adj_matrix, dest)

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
          if acc_cost + line[d] + dest_dist[d] <= time_limit
            # this neighbour is feasible!

            # consider the neighbour's neighbours' max value
            line2 = adj_matrix[d]
            max2 = 0.0
            sum2 = 0.0
            for d2 in 0...n
              if d != d2
                if !line2[d2].nil?
                  if !node_path_hash.has_key?(d2)
                    if acc_cost + line[d] + line2[d2] + dest_dist[d2] <= time_limit
                      m = (node_value[d] + node_value[d2]) / (line[d] + line2[d2])
                      if m > max2
                        max2 = m
                      end
                    end
                  end
                end
              end
            end

            neighbours << [max2 + node_value[d] / line[d], d, acc_cost + line[d], node_path.clone.push(d)]
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

def adjust_matrix(adj_matrix, node_time, origin, dest)
  n = adj_matrix.size

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
end

# find shortest path to all nodes from given origin
def find_way_all(adj_matrix, origin)
  q = PriorityQueue.new
  n = adj_matrix.size

  distance = Array.new(n, 999999) # best known distance to each node
  processed = Array.new(n, false) # if the node has been processed before
  previous = Array.new(n)         # previous node to node => the best known dist

  # all things start from the origin
  distance[origin] = 0
  processed[origin] = true
  q.push([0, origin])

  # keep processing until we're done (reach destination)
  while !q.empty?
    # pop off from PQ
    cost, node = q.pop
    processed[node] = true

    # examine all unvisited neighbours
    neighbours = adj_matrix[node]
    for d in 0...n
      if !processed[d]
        if !neighbours[d].nil?
          # calculate new cost via node to d
          new_cost = distance[node] + neighbours[d]

          # if we have a better path, update
          if new_cost < distance[d]
            distance[d] = new_cost
            previous[d] = node
            q.push([new_cost, d])
          end
        end
      end
    end
  end

  return distance
end

=begin
  PriorityQueue by Ray Toal
  http://cs.lmu.edu/~ray/notes/pqueues/

  Priority Queue, binary heap style, implemented using an array.
  Lower numbers are higher priority.

  Adapted for our purposes:
    - optimised for ruby 1.8.7 performance
    - removed unused methods
    - added the #empty? method
    - changed to sort array elements, with the priority in [0]
      might work with hashes that have the priority in [0]...
    - flattened everything remaining out from the PriorityQueue class
=end
class PriorityQueue
  def initialize
    @heap = []
  end

  def push(x)
    @heap << x
    sift_up(@heap.length - 1)
    self
  end

  def pop
    r = @heap[0]
    if @heap.length == 1
      @heap = []
    else
      @heap[0] = @heap.pop
      sift_down(0)
    end
    return r
  end

  def empty?
    @heap.empty?
  end

  private

  # Sift up the element at index i
  def sift_up(i)
    parent = (i - 1) / 2
    if parent >= 0
      if @heap[parent][0] > @heap[i][0]
        @heap[parent], @heap[i] = @heap[i], @heap[parent]
        sift_up(parent)
      end
    end
  end

  # Sift down the element at index i
  def sift_down(i)
    child = (i * 2) + 1
    if child >= @heap.length
      return
    end
    if child + 1 < @heap.length
      if @heap[child][0] > @heap[child+1][0]
        child += 1
      end
    end
    if @heap[i][0] > @heap[child][0]
      @heap[child], @heap[i] = @heap[i], @heap[child]
      sift_down(child)
    end
  end
end
