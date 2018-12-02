input = File.read("#{__DIR__}/input.txt")
input.lines.each_combination(2) do |(w1, w2)|
  index = nil
  w1.each_char.zip(w2.each_char).with_index do |(c1, c2), i|
    if c1 != c2
      if index
        index = nil # More than one difference
        break
      else
        index = i
      end
    end
  end
  if index
    puts "#{w1[0...index]}#{w1[index + 1..-1]}"
    break
  end
end
