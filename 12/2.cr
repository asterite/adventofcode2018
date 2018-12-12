input = File.read("#{__DIR__}/input.txt").chomp
lines = input.lines
state = lines.shift.split(": ").last.chars.map { |x| x == '#' }

generations = 100

generations.times do
  state.unshift(false)
  state.push(false)
end

lines.shift

mappings = lines.compact_map do |line|
  left, right = line.split(" => ")
  next unless right == "#"
  left.chars.map { |x| x == '#' }
end

generations.times do
  state = state.map_with_index do |plant, i|
    !!mappings.find(&.each_with_index.all? do |p, x|
      state[(i + x - 2) % state.size] == p
    end)
  end
end

count = state.each_with_index.sum { |p, i| p ? i - generations : 0 }
count = count.to_i64 + (50000000000 - generations) * 78
puts count
