serial_number = 1788

grid = (1..300).map do |x|
  (1..300).map do |y|
    rack_id = x + 10
    power_level = rack_id * y
    power_level += serial_number
    power_level *= rack_id
    power_level /= 100
    power_level %= 10
    power_level -= 5
  end
end

solution = (1..298).to_a.repeated_permutations(2).max_by do |(x, y)|
  (x - 1..x + 1).sum do |i|
    (y - 1..y + 1).sum do |j|
      grid[i][j]
    end
  end
end

puts solution.join(",")
