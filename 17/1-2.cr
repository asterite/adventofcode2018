record HorizontalLine, y : Int32, from : Int32, to : Int32 do
  def min_x; from; end
  def max_x; to; end
  def min_y; y; end
  def max_y; y; end
end

record VerticalLine, x : Int32, from : Int32, to : Int32 do
  def min_x; x; end
  def max_x; x; end
  def min_y; from; end
  def max_y; to; end
end

def pg(grid)
  puts grid.join "\n", &.join
  puts
end

input = File.read("#{__DIR__}/input.txt").chomp
lines = input.lines.map do |line|
  case line
  when /x=(\d+), y=(\d+)..(\d+)/
    VerticalLine.new($1.to_i, $2.to_i, $3.to_i)
  when /y=(\d+), x=(\d+)..(\d+)/
    HorizontalLine.new($1.to_i, $2.to_i, $3.to_i)
  else
    raise "unexpected input: #{line}"
  end
end

min_x = lines.min_of(&.min_x)
max_x = lines.max_of(&.max_x)
min_y = lines.min_of(&.min_y)
max_y = lines.max_of(&.max_y)

offset_x = min_x - 1
max_x -= offset_x
min_x = 1

lines.map! do |line|
  if line.is_a?(VerticalLine)
    VerticalLine.new(line.x - offset_x, line.from, line.to)
  else
    HorizontalLine.new(line.y, line.from - offset_x, line.to - offset_x)
  end
end

grid = Array.new(max_y + 2) { Array.new(max_x + 2, '.') }

lines.each do |line|
  if line.is_a?(VerticalLine)
    (line.from..line.to).each do |y|
      grid[y][line.x] = '#'
    end
  else
    (line.from..line.to).each do |x|
      grid[line.y][x] = '#'
    end
  end
end

water_x = 500 - offset_x
water_y = 0

grid[water_y][water_x] = '+'

def set(grid, x, y, value)
  grid[y][x] = value
  # pg(grid)
end

def fall(x, y, grid)
  c = grid[y][x]

  case c
  when '+'
    fall(x, y + 1, grid) if y < grid.size - 1
  when '.'
    set(grid, x, y, '|')
    fall(x, y + 1, grid) if y < grid.size - 1
  when '#'
    set(grid, x, y - 1, '~')
    fill(x, y - 1, grid)
  when '~', '|'
    set(grid, x, y, '~')
    fill(x, y, grid)
  end
end

def fill(x, y, grid)
  right_closed = fill_dir(x, y, grid, +1, nil, false)
  left_closed = fill_dir(x, y, grid, -1, nil, false)
  if left_closed && right_closed
    fill_dir(x, y, grid, +1, '~', false)
    fill_dir(x, y, grid, -1, '~', false)
    fill(x, y - 1, grid)
  else
    fill_dir(x, y, grid, +1, '|', false)
    fill_dir(x, y, grid, -1, '|', false)
    fill_dir(x, y, grid, +1, nil, true)
    fill_dir(x, y, grid, -1, nil, true)
  end
end

def fill_dir(x, y, grid, dir, filler, do_fall)
  return false unless 0 <= x < grid.first.size
  return true if grid[y][x] == '#'

  set(grid, x, y, filler) if filler

  bottom = grid[y + 1][x]
  case bottom
  when '.'
    fall(x, y + 1, grid) if do_fall
    return false
  when '|'
    return false
  end

  fill_dir(x + dir, y, grid, dir, filler, do_fall)
end

fall(water_x, water_y, grid)

water = 0
fall = 0

total_water = (min_y..max_y).each do |y|
  (0..grid.first.size - 1).each do |x|
    c = grid[y][x]
    water += 1 if c == '~'
    fall += 1 if c == '|'
  end
end

pg(grid)

puts "Part 1: #{water + fall}"
puts "Part 2: #{water}"
