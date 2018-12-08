input = File.read("#{__DIR__}/input.txt")
numbers = input.split.map(&.to_i).reverse

def read_node(numbers)
  child_nodes = numbers.pop
  metadata_nodes = numbers.pop

  sum = 0
  child_nodes.times do
    sum += read_node(numbers)
  end
  metadata_nodes.times do
    sum += numbers.pop
  end
  sum
end

puts read_node(numbers)
