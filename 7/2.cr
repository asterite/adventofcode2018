class Step
  getter name, :next, prev

  def initialize(@name : Char)
    @next = [] of Step
    @prev = [] of Step
  end

  def time
    61 + (name - 'A')
  end
end

class Worker
  property step : Step?
  property time = 0
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

total_time = 0
done = 0
workers = Array.new(5) { Worker.new }
free_steps = steps.values.select &.prev.empty?

steps.size.times do
  free_steps.sort_by! &.name

  workers.each do |worker|
    break if free_steps.empty?
    next if worker.step

    free_step = free_steps.shift
    worker.step = free_step
    worker.time = free_step.time
  end

  next_worker = workers.select(&.step).min_by(&.time)
  step = next_worker.step.not_nil!
  step_time = next_worker.time

  total_time += step_time

  next_worker.step = nil

  workers.each do |worker|
    next if worker == next_worker
    worker.time -= step_time
  end

  step.next.each &.prev.delete(step)
  free_steps.concat(step.next.select &.prev.empty?)
end

puts total_time
