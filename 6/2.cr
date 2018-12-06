input = File.read("#{__DIR__}/input.txt").chomp

points = input.lines.map do |line|
  line.split(", ").map(&.to_i)
end

width = points.max_of(&.[0]) + 1
height = points.max_of(&.[1]) + 1

grid = Array.new(width) { Array.new(height, 0) }

width.times do |x|
  height.times do |y|
    grid[x][y] = points.sum { |(px, py)| (x - px).abs + (y - py).abs }
  end
end

puts grid.sum &.count &.<(10_000)
