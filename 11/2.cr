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

max = Int32::MIN
max_x = nil
max_y = nil
max_z = nil

(1..300).each do |x|
  (1..300).each do |y|
    max_width = {300 - x + 1, 300 - y + 1}.min
    (1..max_width).each do |z|
      power = (x - 1..x - 1 + z - 1).sum do |i|
        (y - 1..y - 1 + z - 1).sum do |j|
          grid[i][j]
        end
      end
      if power > max
        max = power
        max_x = x
        max_y = y
        max_z = z
      end
    end
  end
end

puts "#{max_x},#{max_y},#{max_z}"
