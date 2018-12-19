abstract class Op
  ALL = {} of String => Op

  abstract def execute(a, b, c, registers)

  def self.[](name)
    ALL[name]
  end
end

macro def_op(name, code)
  class {{name.id.capitalize}} < Op
    def execute(a, b, c, r)
      r[c] = {{code}}
    end

    ALL[{{name.id.stringify}}] = new
  end
end

def_op :addr, r[a] + r[b]
def_op :addi, r[a] + b
def_op :mulr, r[a] * r[b]
def_op :muli, r[a] * b
def_op :banr, r[a] & r[b]
def_op :bani, r[a] & b
def_op :borr, r[a] | r[b]
def_op :bori, r[a] | b
def_op :setr, r[a]
def_op :seti, a
def_op :gtir, a > r[b] ? 1 : 0
def_op :gtri, r[a] > b ? 1 : 0
def_op :gtrr, r[a] > r[b] ? 1 : 0
def_op :eqir, a == r[b] ? 1 : 0
def_op :eqri, r[a] == b ? 1 : 0
def_op :eqrr, r[a] == r[b] ? 1 : 0

record SetIp, value : Int32

record Instruction,
  op : Op,
  a : Int32,
  b : Int32,
  c : Int32 do
  def to_s(io)
    io << op.class.name.downcase << " " << a << " " << b << " " << c
  end
end

input = File.read("#{__DIR__}/input.txt").chomp
lines = input.lines
ipr = lines.shift.split[1].to_i
registers = [0, 0, 0, 0, 0, 0]
ip = 0

code = lines.map do |line|
  name, a, b, c = line.split
  a, b, c = {a, b, c}.map(&.to_i)
  op = Op[name]
  Instruction.new(op, a, b, c)
end

while true
  inst = code[ip]?
  break unless inst

  registers[ipr] = ip
  # print "ip=#{ip} #{registers} "
  # print inst

  inst.op.execute(inst.a, inst.b, inst.c, registers)
  ip = registers[ipr]
  # print " #{registers}"
  # puts
  ip += 1
end

p registers
