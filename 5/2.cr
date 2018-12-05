input = File.read("#{__DIR__}/input.txt").chomp

min = ('a'..'z').min_of do |target|
  chars = input.chars
  chars.reject! do |c|
    c.downcase == target || c.upcase == target
  end

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

  chars.size
end

puts min
