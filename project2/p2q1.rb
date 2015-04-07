def lightning(a, y, x)
  # nothing to do if this is already 0
  return a if a[y][x] == 0

  # retrieve the dimensions for bounds checking later
  height = a.length     # y
  width = a[0].length   # x

  # prepare the stack
  st = []
  st.push([y, x])

  # loop until done
  until st.empty? do
    # for the current cell, set to 0
    yy, xx = st.pop
    a[yy][xx] = 0

    # examine all the neighbours, push if they're 1
    # top
    st.push([yy-1, xx]) if yy-1 >= 0 && a[yy-1][xx] == 1
    # right
    st.push([yy, xx+1]) if xx+1 < width && a[yy][xx+1] == 1
    # bottom
    st.push([yy+1, xx]) if yy+1 < height && a[yy+1][xx] == 1
    # left
    st.push([yy, xx-1]) if xx-1 >= 0 && a[yy][xx-1] == 1
  end

  return a
end
