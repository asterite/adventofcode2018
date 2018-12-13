class Cart
  getter x : Int32, y : Int32
  getter direction : Symbol
  getter turn : Symbol

  def initialize(@x, @y, @direction)
    @turn = :left
  end

  def advance(map)
    char = map[@y][@x]
    case char
    when '-'
      direction == :left ? left : right
    when '|'
      direction == :up ? up : down
    when '\\'
      case direction
      when :left  then up
      when :right then down
      when :up    then left
      else             right
      end
    when '/'
      case direction
      when :left  then down
      when :right then up
      when :up    then right
      else             left
      end
    when '+'
      case turn
      when :left
        case direction
        when :left  then down
        when :right then up
        when :up    then left
        else             right
        end
        @turn = :straight
      when :straight
        case direction
        when :left  then left
        when :right then right
        when :up    then up
        else             down
        end
        @turn = :right
      else
        case direction
        when :left  then up
        when :right then down
        when :up    then right
        else             left
        end
        @turn = :left
      end
    end
  end

  def up
    @y -= 1
    @direction = :up
  end

  def down
    @y += 1
    @direction = :down
  end

  def left
    @x -= 1
    @direction = :left
  end

  def right
    @x += 1
    @direction = :right
  end

  def to_s(io)
    io << case direction
    when :left  then '<'
    when :right then '>'
    when :up    then '^'
    else             'v'
    end
  end
end

input = File.read("#{__DIR__}/input.txt").chomp

carts = [] of Cart

map = input.lines.map_with_index do |line, y|
  line.chars.map_with_index do |char, x|
    case char
    when '>'
      carts << Cart.new(x, y, :right)
      char = '-'
    when '<'
      carts << Cart.new(x, y, :left)
      char = '-'
    when '^'
      carts << Cart.new(x, y, :up)
      char = '|'
    when 'v'
      carts << Cart.new(x, y, :down)
      char = '|'
    end
    char
  end
end

def print_map(map, carts)
  map.each_with_index do |line, y|
    line.each_with_index do |char, x|
      cart = carts.find { |c| c.x == x && c.y == y }
      if cart
        print cart
      else
        print char
      end
    end
    puts
  end
  puts
end

loop do
  carts.sort_by! { |c| {c.y, c.x} }

  carts.each do |cart|
    cart.advance(map)

    crash = carts.find do |other_cart|
      !other_cart.same?(cart) &&
        cart.x == other_cart.x &&
        cart.y == other_cart.y
    end
    if crash
      puts "#{crash.x},#{crash.y}"
      exit
    end
  end
end
