input = File.read("#{__DIR__}/input.txt")
frequencies = input.split.map(&.to_i)

current = 0
seen = Set{current}

frequencies.cycle.each do |frequency|
  current += frequency

  if seen.includes?(current)
    break
  end

  seen.add(current)
end

puts current
