# broken pseudo sfpa implementation
def find_way(adj_matrix, origin, dest)
  n = adj_matrix.size
  dist = Array.new(n) { 999999 } # init to infinity
  q = [] # temp q
  edges = []

  for s in 0...n do
    for d in 0...n do
      edges << [s, d, adj_matrix[s][d]] unless adj_matrix[s][d].nil?
    end
  end

  dist[origin] = 0
  q.push origin

  # find shortest distance to all points from single source
  until q.empty?
    node = q.shift
    for e in edges do
      s = e[0]
      d = e[1]
      w = e[2]
      if dist[s] + w < dist[d]
        dist[d] = dist[s] + w
        q.push(d) unless q.include?(d)
        # SLF
        q.unshift(q.pop) if dist[q.last] < dist[q.first]
      end
    end
  end

  # backtrack to find path
  path = [dest]
  shortest = dist[dest]
  remaining_dist = shortest
  current_step = dest

  while remaining_dist > 0 do
    done = false
    for neighbour in 0...n do
      unless adj_matrix[neighbour][current_step].nil? || done
        if dist[neighbour] + adj_matrix[neighbour][current_step] == dist[current_step]
          remaining_dist -= adj_matrix[neighbour][current_step]
          current_step = neighbour
          path.push(neighbour)
          done = true
        end
      end
      break if done
    end
  end

  return path.reverse
end
