# Runs in Ruby and Crystal! :-)

nums = [3, 7]
elves = [0, 1]
recipes = 633601

while nums.size < recipes + 10
  sum = elves.sum { |e| nums[e] }

  new_recipe1 = sum / 10
  new_recipe2 = sum % 10

  nums << new_recipe1 if new_recipe1 != 0
  nums << new_recipe2

  elves.map! { |e| (e + nums[e] + 1) % nums.size }
end

puts nums[recipes...recipes + 10].join
