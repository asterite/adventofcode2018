input = File.read("#{__DIR__}/input.txt").chomp
lines = input.lines
state = lines.shift.split(": ").last.chars.map { |x| x == '#' }

generations = 20

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

puts state.map { |x| x ? '#' : '.' }.join
generations.times do
  state = state.map_with_index do |plant, i|
    !!mappings.find(&.each_with_index.all? do |p, x|
      state[(i + x - 2) % state.size] == p
    end)
  end
end

puts state.each_with_index.sum { |p, i| p ? i - generations : 0 }
