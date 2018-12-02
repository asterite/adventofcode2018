input = File.read("#{__DIR__}/input.txt")
puts({2, 3}.product do |target|
  input.each_line.count do |line|
    line.each_char.group_by(&.itself).any? do |k, v|
      v.size == target
    end
  end
end)
