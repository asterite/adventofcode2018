class Point
  property id, x, y
  property? infinite = false

  def initialize(@id : Int32, @x : Int32, @y : Int32)
  end

  def distance_to(x, y)
    (@x - x).abs + (@y - y).abs
  end
end

class Entry
  property min_distance = Int32::MAX

  # All points that are at a minimum distance
  property points = [] of Point

  # The single point that is at a minimum distance
  def point
    points.size == 1 ? points.first : nil
  end
end

input = File.read("#{__DIR__}/input.txt").chomp

points = input.lines.map_with_index do |line, i|
  x, y = line.split(", ").map(&.to_i)
  Point.new(i, x, y)
end

# We extend the grid and shift all points based on the maximum
# x/y distance between all of them. So if the maximum x distance
# is 10 we shift the points by 10 and make the grid be 30 units wide.

min_x, max_x = points.minmax_of(&.x)
min_y, max_y = points.minmax_of(&.y)
diff_x = max_x - min_x
diff_y = max_y - min_y

points.each do |point|
  point.x += diff_x
  point.y += diff_y
end

width = diff_x * 3
height = diff_y * 3

grid = Array.new(width) { Array.new(height) { Entry.new } }

# Compute minimum distance and points at each entry
grid.each_with_index do |column, y|
  column.each_with_index do |entry, x|
    points.each do |point|
      distance = point.distance_to(x, y)
      if distance < entry.min_distance
        entry.min_distance = distance
        entry.points.clear
        entry.points << point
      elsif distance == entry.min_distance
        entry.points << point
      end
    end
  end
end

# Minimum distance points at the left and right edges extend infinitely
{0, width - 1}.each do |x|
  (0...height).each do |y|
    entry = grid[x][y]
    entry.point.try &.infinite=(true)
  end
end

# Minimum distance points at the top and bottom edges extend infinitely
{0, height - 1}.each do |y|
  (0...width).each do |x|
    entry = grid[x][y]
    entry.point.try &.infinite=(true)
  end
end

counts = Array.new(points.size, 0)

grid.each do |column|
  column.each do |entry|
    point = entry.point
    if point && !point.infinite?
      counts[point.id] += 1
    end
  end
end

puts counts.max
