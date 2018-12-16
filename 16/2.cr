record Instruction,
  opcode : Int32,
  a : Int32,
  b : Int32,
  c : Int32

record Sample,
  instruction : Instruction,
  before : Array(Int32),
  after : Array(Int32)

abstract class Op
  ALL = [] of Op

  macro inherited
    ALL << {{@type}}.new
  end

  abstract def execute(a, b, c, registers)
end

macro def_op(name, code)
  class {{name.id.capitalize}} < Op
    property! opcode : Int32

    def execute(a, b, c, r)
      r[c] = {{code}}
    end
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
def_op :gtrl, r[a] > r[b] ? 1 : 0
def_op :eqir, a == r[b] ? 1 : 0
def_op :eqri, r[a] == b ? 1 : 0
def_op :eqrr, r[a] == r[b] ? 1 : 0

def parse_instruction(line)
  opcode, a, b, c = line.split.map(&.to_i)
  Instruction.new(opcode, a, b, c)
end

input = File.read("#{__DIR__}/input.txt").chomp
lines = input.lines.reverse

samples = [] of Sample

while true
  line = lines.pop
  next if line.empty?

  match = line.match(/Before:\s*\[(.+)\]/)
  unless match
    lines.push(line)
    break
  end

  before = match[1].not_nil!.split(",").map(&.to_i)

  instruction = parse_instruction(lines.pop)

  match = lines.pop.match(/After:\s*\[(.+)\]/).not_nil!
  after = match[1].not_nil!.split(",").map(&.to_i)

  samples << Sample.new(instruction, before, after)
end

program = lines.reverse.reject(&.empty?).map { |line| parse_instruction(line) }

until Op::ALL.all?(&.opcode?)
  samples.each do |sample|
    inst = sample.instruction

    ops = Op::ALL.select do |op|
      next if op.opcode?

      registers = sample.before.dup
      op.execute(inst.a, inst.b, inst.c, registers)
      registers == sample.after
    end

    ops.first.opcode = inst.opcode if ops.size == 1
  end
end

ops = Op::ALL.map { |op| {op.opcode, op} }.to_h

registers = [0, 0, 0, 0]
program.each do |inst|
  op = ops[inst.opcode]
  op.execute(inst.a, inst.b, inst.c, registers)
end

puts registers[0]
