class Point
  getter x, y

  def initialize(@x : Int32, @y : Int32, @dx : Int32, @dy : Int32)
  end

  def advance
    @x += @dx
    @y += @dy
  end
end

input = File.read("#{__DIR__}/input.txt").chomp
points = input.lines.map do |line|
  match = line.match(/position=<\s*(-?\d+),\s*(-?\d+)> velocity=<\s*(-?\d+),\s*(-?\d+)>/)
  x, y, dx, dy = match.not_nil!.captures.map(&.not_nil!.to_i)
  Point.new(x, y, dx, dy)
end

seconds = 0

loop do
  min_x, max_x = points.minmax_of(&.x)
  min_y, max_y = points.minmax_of(&.y)

  if max_y - min_y < 12
    puts "At #{seconds} seconds:"
    (min_y..max_y).each do |y|
      (min_x..max_x).each do |x|
        point = points.find { |p| p.x == x && p.y == y }
        if point
          print '#'
        else
          print '.'
        end
      end
      puts
    end
    break
  end

  points.each &.advance
  seconds += 1
end
