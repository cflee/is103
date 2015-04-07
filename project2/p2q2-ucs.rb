def find_way(adj_matrix, origin, dest)
  # UCS
  q = PriorityQueue.new
  n = adj_matrix.size
  processed = Array.new(n, false)
  previous = Array.new(n)
  q.push([origin, 0, nil])

  while !q.empty?
    node, cost, prev = q.pop

    # ignore if already dequeued before since this PQ may have the same node
    # multiple times at different priorities
    if !processed[node]
      if node == dest
        # reached
        # backtrack to find the path
        path = [node]
        last_node = prev
        while !last_node.nil?
          path.push(last_node)
          last_node = previous[last_node]
        end
        return path.reverse
      else
        # not there yet
        # iterate over all the outbound edges
        neighbours = adj_matrix[node]
        for i in 0...n
          if !neighbours[i].nil?
            # determine if neighbouring node has been dequeued before
            if !processed[i]
              w = cost + neighbours[i]
              q.push([i, w, node])
            end
          end
        end
      end

      processed[node] = true
      previous[node] = prev # mark dequeued node as processed
    end
  end
end

=begin
  PriorityQueue by Ray Toal
  http://cs.lmu.edu/~ray/notes/pqueues/

  Priority Queue, binary heap style, implemented using an array.
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

  def peek
    @heap[0]
  end

  def remove!()
    raise RuntimeError, "Empty Queue" if @heap.length == 0
    if @heap.length == 1
      @heap = []
    else
      @heap[0] = @heap.pop
      sift_down(0)
    end
    self
  end

  def pop
    r = @heap[0]
    remove!
    return r
  end

  def empty?
    @heap.empty?
  end

  def to_s
    @heap.to_s
  end

  private

  # Sift up the element at index i
  def sift_up(i)
    parent = (i - 1) / 2
    if parent >= 0 and @heap[parent][1] > @heap[i][1]
      @heap[parent], @heap[i] = @heap[i], @heap[parent]
      sift_up(parent)
    end
  end

  # Sift down the element at index i
  def sift_down(i)
    child = (i * 2) + 1
    return if child >= @heap.length
    child += 1 if child + 1 < @heap.length and @heap[child][1] > @heap[child+1][1]
    if @heap[i][1] > @heap[child][1]
      @heap[child], @heap[i] = @heap[i], @heap[child]
      sift_down(child)
    end
  end
end
