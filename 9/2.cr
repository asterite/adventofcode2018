class Marble
  property! next : Marble
  property! prev : Marble
  getter value : Int32

  def initialize(@value : Int32)
    @next = self
    @prev = self
  end

  def +(value)
    marble = self
    value.times { marble = marble.next }
    marble
  end

  def -(value)
    marble = self
    value.times { marble = marble.prev }
    marble
  end

  def insert(value)
    new_marble = Marble.new(value)
    new_marble.next = self.next
    new_marble.prev = self
    self.next.prev = new_marble
    self.next = new_marble
  end

  def delete
    self.next.prev = self.prev
    self.prev.next = self.next
    ret = self.next
    @next = nil
    @prev = nil
    ret
  end
end

marble = Marble.new(0)
scores = Array.new(466, 0_i64)
player = 0
index = 0

(1..7143600).each do |value|
  if value.divisible_by?(23)
    marble -= 7
    scores[player] += value + marble.value
    marble = marble.delete
  else
    marble += 1
    marble = marble.insert(value)
  end
  player = (player + 1) % scores.size
end

puts scores.max
