def each_adjacent(map, x, y)
  yield map[y - 1][x - 1] if x > 0 && y > 0
  yield map[y - 1][x] if y > 0
  yield map[y - 1][x + 1] if x < map.first.size - 1 && y > 0
  yield map[y][x - 1] if x > 0
  yield map[y][x + 1] if x < map.first.size - 1
  yield map[y + 1][x - 1] if x > 0 && y < map.size - 1
  yield map[y + 1][x] if y < map.size - 1
  yield map[y + 1][x + 1] if x < map.first.size - 1 && y < map.size - 1
end

input = File.read("#{__DIR__}/input.txt").chomp

map = input.lines.map &.chars
next_map = map.clone

chain = {} of typeof(map) => typeof(map)

# puts "Initial state:"
# puts map.join "\n", &.join
# puts

1000000000.times do |i|
  puts chain.size

  if chain_map = chain[map]?
    puts "ACA!"
    break
  end

  map.each_with_index do |row, y|
    row.each_with_index do |char, x|
      open = 0
      trees = 0
      lumberyards = 0
      each_adjacent(map, x, y) do |achar|
        open += 1 if achar == '.'
        trees += 1 if achar == '|'
        lumberyards += 1 if achar == '#'
      end

      next_map[y][x] =
        case char
        when '.'
          trees >= 3 ? '|' : '.'
        when '|'
          lumberyards >= 3 ? '#' : '|'
        else
          lumberyards >= 1 && trees >= 1 ? '#' : '.'
        end
    end
  end

  chain[map.clone] = next_map.clone

  map, next_map = next_map, map
  # puts "After #{i + 1} minutes:"
  # puts map.join "\n", &.join
  # puts
end

trees = 0
lumberyards = 0

map.each do |row|
  row.each do |char|
    trees += 1 if char == '|'
    lumberyards += 1 if char == '#'
  end
end

puts trees * lumberyards
