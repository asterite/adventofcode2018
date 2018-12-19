x = 10551330
puts (1..x).sum { |y| x.divisible_by?(y) ? y : 0 }
