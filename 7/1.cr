class Step
  getter name, :next, prev

  def initialize(@name : Char)
    @next = [] of Step
    @prev = [] of Step
  end
end

input = File.read("#{__DIR__}/input.txt").chomp

steps = Hash(Char, Step).new { |h, k| h[k] = Step.new(k) }

input.each_line do |line|
  line =~ /Step (\w) must be finished before step (\w) can begin./
  c1, c2 = $1[0], $2[0]
  s1, s2 = steps[c1], steps[c2]
  s1.next << s2
  s2.prev << s1
end

order = [] of Char

free_steps = steps.values.select { |step| step.prev.empty? }

steps.size.times do
  free_steps.sort_by!(&.name)
  free_step = free_steps.shift
  order << free_step.name

  new_free_steps = free_step.next.select do |next_step|
    next_step.prev.delete(free_step)
    next_step.prev.empty?
  end

  free_steps.concat(new_free_steps)
end

puts order.join
