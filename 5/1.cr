input = File.read("#{__DIR__}/input.txt").chomp
chars = input.chars

deleted = true
while deleted
  deleted = false

  i = 0
  while i < chars.size - 1
    a, b = chars[i], chars[i + 1]
    if (a.lowercase? ? a.upcase : a.downcase) == b
      chars.delete_at(i..i + 1)
      deleted = true
    end
    i += 1
  end
end

puts chars.size
