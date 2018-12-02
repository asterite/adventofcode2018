input = File.read("#{__DIR__}/input.txt")

two_count = 0
three_count = 0
letter_count = Hash(Char, Int32).new { |h, k| h[k] = 0 }

input.each_line do |line|
  letter_count.clear

  line.each_char do |char|
    letter_count[char] += 1
  end

  has_two = false
  has_three = false

  letter_count.each_value do |value|
    has_two = true if value == 2
    has_three = true if value == 3
  end

  two_count += 1 if has_two
  three_count += 1 if has_three
end

puts two_count * three_count
