input = File.read("#{__DIR__}/input.txt")
numbers = input.split.map(&.to_i).reverse

class Node
  property children = [] of Node
  property metadata_nodes = [] of Int32

  getter value : Int32 do
    if children.empty?
      metadata_nodes.sum
    else
      metadata_nodes.sum do |index|
        children[index - 1]?.try(&.value) || 0
      end
    end
  end
end

def read_node(numbers)
  node = Node.new

  child_nodes = numbers.pop
  metadata_nodes = numbers.pop

  child_nodes.times do
    node.children << read_node(numbers)
  end
  metadata_nodes.times do
    node.metadata_nodes << numbers.pop
  end

  node
end

puts read_node(numbers).value
