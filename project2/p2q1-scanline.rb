# scanline fill implementation adapted from somewhere on the internet
def lightning(a, y, x)
  # nothing to do if this is already 0
  return a if a[y][x] == 0

  # retrieve the dimensions for bounds checking later
  height = a.length     # y
  width = a[0].length   # x
  sl = 0
  sr = 0

  # prepare the stack
  st = []
  st.push([y, x])

  until st.empty?
    yy, xx = st.pop

    # find the leftmost continuous 1 on this row
    xx -= 1 while xx > 0 && a[yy][xx-1] == 1

    # keep track of whether there is a continuous chunk on the top/bottom
    top_cont = false
    btm_cont = false

    # iterate from left to right
    # this reduces number of stack push/pop operations
    while xx < width && a[yy][xx] == 1
      # clear the current cell
      a[yy][xx] = 0

      # check upstairs
      if top_cont == false && yy > 0 && a[yy-1][xx] == 1
        # we just found the leftmost cell of a new chunk
        st.push([yy-1, xx])
        top_cont = true
      elsif top_cont == true && yy > 0 && a[yy-1][xx] == 0
        # there was a chunk but it ended, reset flag
        top_cont = false
      end

      # check downstairs
      if btm_cont == false && yy < height-1 && a[yy+1][xx] == 1
        st.push([yy+1, xx])
        btm_cont = true
      elsif btm_cont == true && yy < height-1 && a[yy+1][xx] == 0
        btm_cont = false
      end

      # move to the right
      xx += 1
    end
  end

  return a
end
