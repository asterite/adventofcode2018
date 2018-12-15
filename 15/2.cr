module Wall
  def self.to_s(io)
    io << '#'
  end
end

module Ground
  def self.to_s(io)
    io << '.'
  end
end

def surroundings(map, x, y)
  yield x, y - 1 if y < map.size
  yield x - 1, y if x > 0
  yield x + 1, y if x < map.first.size
  yield x, y + 1 if y > 0
end

def print_map(map)
  map.each do |line|
    units = [] of Unit

    line.each do |unit|
      units << unit if unit.is_a?(Unit)
      print unit
    end

    units.each do |unit|
      print "  #{unit}(#{unit.hit_points})"
    end
    puts
  end
  puts
end

class Unit
  getter x, y
  getter? elf
  property attack_power
  property hit_points
  property? dead = false

  def initialize(@x : Int32, @y : Int32, @elf : Bool)
    @attack_power = 3
    @hit_points = 200
  end

  def goblin?
    !elf?
  end

  def fill_steps_map(steps_map, map)
    fill_steps_map(steps_map, map, @x, @y, 0)
  end

  def fill_steps_map(steps_map, map, x, y, steps)
    return unless 0 <= y < map.size
    return unless 0 <= x < map.first.size

    current_steps = steps_map[y][x]
    return if !current_steps.nil? && current_steps <= steps

    object = map[y][x]
    return unless object == self || object.is_a?(Ground.class)

    steps_map[y][x] = steps
    steps += 1

    surroundings(map, x, y) do |nx, ny|
      fill_steps_map(steps_map, map, nx, ny, steps)
    end
  end

  def next_move_target(steps_map, map)
    min_steps = Int32::MAX
    min_x = nil
    min_y = nil
    steps_map.each_with_index do |line, y|
      line.each_with_index do |steps, x|
        if steps && steps < min_steps && has_enemy_around?(map, x, y)
          min_steps = steps
          min_x = x
          min_y = y
        end
      end
    end
    min_x && min_y ? {min_x, min_y} : nil
  end

  def enemy?(unit)
    elf? != unit.elf?
  end

  def has_enemy_around?(map, x, y)
    surroundings(map, x, y) do |nx, ny|
      unit = map[ny][nx]
      return true if unit.is_a?(Unit) && enemy?(unit)
    end
    false
  end

  def has_self_around?(map, x, y)
    surroundings(map, x, y) do |nx, ny|
      return true if map[ny][nx] == self
    end
    false
  end

  def next_move(steps_map, map, x, y, min_x = nil, min_y = nil)
    current_steps = steps_map[y][x].not_nil!
    if current_steps == 1 && has_self_around?(map, x, y)
      if min_x && min_y
        if {y, x} < {min_y, min_x}
          return x, y
        else
          return nil
        end
      else
        return x, y
      end
    end

    surroundings(map, x, y) do |nx, ny|
      if steps_map[ny][nx] == current_steps - 1
        next_move = next_move(steps_map, map, nx, ny, min_x, min_y)
        min_x, min_y = next_move if next_move
      end
    end

    min_x && min_y ? {min_x, min_y} : nil
  end

  def find_enemy(map)
    min_unit = nil

    surroundings(map, @x, @y) do |nx, ny|
      unit = map[ny][nx]
      if unit.is_a?(Unit) && enemy?(unit)
        if min_unit
          if unit.hit_points < min_unit.hit_points
            min_unit = unit
          end
        else
          min_unit = unit
        end
      end
    end

    min_unit
  end

  def move_to(x, y, map)
    map[@y][@x] = Ground
    @x, @y = x, y
    map[@y][@x] = self
  end

  def attack(unit, map)
    unit.hit_points -= attack_power
    if unit.hit_points <= 0
      unit.dead = true
      map[unit.y][unit.x] = Ground
    end
  end

  def clone
    unit = Unit.new(@x, @y, @elf)
    unit.hit_points = @hit_points
    unit.attack_power = @attack_power
    unit.dead = @dead
    unit
  end

  def inspect(io)
    to_s(io)
  end

  def to_s(io)
    io << (elf? ? 'E' : 'G')
  end
end

alias Entry = Wall.class | Ground.class | Unit

units = [] of Unit

input = File.read("#{__DIR__}/input.txt").chomp
map = input.lines.map_with_index do |line, y|
  line.chars.map_with_index do |char, x|
    case char
    when 'E'
      Unit.new(x, y, true)
    when 'G'
      Unit.new(x, y, false)
    when '#'
      Wall
    else
      Ground
    end
  end
end

steps_map = map.map &.map { nil.as(Int32?) }

original_map = map.clone
attack_power = 3

while true
  map = original_map.clone
  units = map.flat_map { |line| line.compact_map(&.as?(Unit)) }

  units.each do |unit|
    unit.attack_power = attack_power if unit.elf?
  end

  rounds = 0
  elf_died = false

  # puts rounds
  # print_map(map)

  while true
    units.sort_by! { |u| {u.y, u.x} }

    units.each_with_index do |unit|
      next if unit.dead?

      enemy = unit.find_enemy(map)

      # If there's no enemy, move first
      unless enemy
        steps_map.each &.fill(nil)
        unit.fill_steps_map(steps_map, map)

        next_move_target = unit.next_move_target(steps_map, map)
        if next_move_target
          next_move = unit.next_move(steps_map, map, *next_move_target).not_nil!
          unit.move_to(*next_move, map)

          # After a move, find an enemy
          enemy = unit.find_enemy(map)
        end
      end

      if enemy
        unit.attack(enemy, map)

        if enemy.dead?
          if enemy.elf?
            # puts "Elf died with attack power #{attack_power} :-("
            # puts
            elf_died = true
            attack_power += 1
            break
          end

          remaining_units = units.reject(&.dead?)
          if remaining_units.all?(&.elf?) || remaining_units.all?(&.goblin?)
            # If this was the last unit in this loop a full round is complete
            if remaining_units.index(unit) == remaining_units.size - 1
              rounds += 1
            end

            hit_points = remaining_units.sum(&.hit_points)
            # print_map(map)
            score = rounds * hit_points
            p! rounds, attack_power, hit_points, score
            exit
          end
        end
      end
    end

    break if elf_died

    units.reject!(&.dead?)

    rounds += 1
    # puts rounds
    # print_map(map)
  end
end
