input = File.read("#{__DIR__}/input.txt")

fabric = Array.new(1000) { Array.new(1000, 0) }

claims = input.lines.compact_map do |line|
  next if line.empty?

  match = line.match(/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/)
  match.not_nil!.captures.map(&.not_nil!.to_i)
end

# mark
claims.each do |(id, left, top, width, height)|
  width.times do |x|
    height.times do |y|
      fabric[left + x][top + y] += 1
    end
  end
end

# check
claims.each do |(id, left, top, width, height)|
  all_ones = (0...width).all? do |x|
    (0...height).all? do |y|
      fabric[left + x][top + y] == 1
    end
  end
  if all_ones
    puts id
    break
  end
end
