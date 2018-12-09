marbles = [0]
scores = Array.new(466, 0)
player = 0
index = 0

(1..71436).each do |value|
  if value.divisible_by?(23)
    index = (index - 7) % marbles.size
    scores[player] += value + marbles.delete_at(index)
  else
    index = (index + 2) % marbles.size
    marbles.insert(index, value)
  end
  player = (player + 1) % scores.size
end

puts scores.max
