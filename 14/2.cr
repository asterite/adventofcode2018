# Runs in Ruby and Crystal! :-)
# If you run it with Ruby 2.6.0-rc1 it takes (for me) 11.454s
# If you run it with Crystal without --release it takes 2.963s
# If you run it with Crystal with --release it takes 0.787s

nums = [3, 7]
elves = [0, 1]
current = 37
target_string = "633601"
target = target_string.to_i
target_size = target_string.size
exp = 10 ** target_size

def adjust(value, nums, current, exp)
  nums << value
  current *= 10
  left_digit = current / exp
  current -= left_digit * exp if left_digit != 0
  current += value
  current
end

while true
  sum = elves.sum { |e| nums[e] }

  new_recipe1 = sum / 10
  new_recipe2 = sum % 10

  if new_recipe1 != 0
    current = adjust(new_recipe1, nums, current, exp)
    break if current == target
  end

  current = adjust(new_recipe2, nums, current, exp)
  break if current == target

  elves.map! { |e| (e + nums[e] + 1) % nums.size }
end

puts nums.size - target_size
