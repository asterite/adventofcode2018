input = File.read("#{__DIR__}/input.txt")

entries = input.lines.compact_map do |line|
  next if line.empty?

  match = line.match(/\[(.+)\] (.+)/).not_nil!
  time = Time.parse_utc(match[1], "%F %H:%M")
  sleep = false

  case match[2]
  when /Guard #(\d+) begins shift/
    guard = $1.to_i
  when /falls asleep/
    sleep = true
  end

  {time, guard, sleep}
end

entries.sort_by!(&.[0])

# guard -> minute -> amount
sleep_minutes = Hash(Int32, Hash(Int32, Int32)).new do |h, k|
  h[k] = Hash(Int32, Int32).new(0)
end

time, guard, sleep = entries.shift
guard = guard.not_nil!

entries.each do |next_time, next_guard, next_sleep|
  if next_guard
    guard = next_guard
  elsif sleep && !next_sleep
    while time < next_time
      sleep_minutes[guard][time.minute] += 1
      time += 1.minute
    end
  end

  time = next_time
  sleep = next_guard ? false : next_sleep
end

sleepy_guard, minutes = sleep_minutes.max_by &.[1].each_value.max
minute, amount = minutes.max_by &.[1]
puts sleepy_guard * minute
