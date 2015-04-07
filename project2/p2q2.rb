def find_way(adj_matrix, origin, dest)
  @heap = []
  found = false

  n = adj_matrix.size
  distance = Array.new(n, 999999) # best known distance to each node
  processed = Array.new(n, false) # if the node has been processed before
  previous = Array.new(n)         # previous node to node => the best known dist

  # all things start from the origin
  distance[origin] = 0
  processed[origin] = true
  push([origin, 0])

  # keep processing until we're done (reach destination)
  while !@heap.empty?
    # pop off from PQ
    node, cost = pop
    processed[node] = true

    if node == dest
      found = true
      break
    end

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
            push([d, new_cost])
          end
        end
      end
    end
  end

  if !found
    return nil
  end

  # backtrack to find path from origin to destination
  path = []
  prev_node = dest
  while !prev_node.nil?
    path.push(prev_node)
    prev_node = previous[prev_node]
  end

  return path.reverse!
end

=begin
  PriorityQueue by Ray Toal
  http://cs.lmu.edu/~ray/notes/pqueues/

  Priority Queue, binary heap style, implemented using an array.

  Adapted for our purposes:
    - optimised for ruby 1.8.7 performance
    - removed unused methods
    - changed to sort an array of two elements, with the priority in [1]
    - flattened everything remaining out from the PriorityQueue class
=end
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
  r
end

# Sift up the element at index i
def sift_up(i)
  parent = (i - 1) / 2
  if parent >= 0
    if @heap[parent][1] > @heap[i][1]
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
    if @heap[child][1] > @heap[child+1][1]
      child += 1
    end
  end
  if @heap[i][1] > @heap[child][1]
    @heap[child], @heap[i] = @heap[i], @heap[child]
    sift_down(child)
  end
end
