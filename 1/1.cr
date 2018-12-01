input = File.read("#{__DIR__}/input.txt")
puts input.split.map(&.to_i).sum
