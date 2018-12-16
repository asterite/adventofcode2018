abstract class Instruction
  ALL = [] of Instruction

  macro inherited
    ALL << {{@type}}.new
  end

  abstract def execute(a, b, c, registers)
end

macro def_instruction(name, code)
  class {{name.id.capitalize}} < Instruction
    def execute(a, b, c, r)
      r[c] = {{code}}
    end
  end
end

def_instruction :addr, r[a] + r[b]
def_instruction :addi, r[a] + b
def_instruction :mulr, r[a] * r[b]
def_instruction :muli, r[a] * b
def_instruction :banr, r[a] & r[b]
def_instruction :bani, r[a] & b
def_instruction :borr, r[a] | r[b]
def_instruction :bori, r[a] | b
def_instruction :setr, r[a]
def_instruction :seti, a
def_instruction :gtir, a > r[b] ? 1 : 0
def_instruction :gtri, r[a] > b ? 1 : 0
def_instruction :gtrl, r[a] > r[b] ? 1 : 0
def_instruction :eqir, a == r[b] ? 1 : 0
def_instruction :eqri, r[a] == b ? 1 : 0
def_instruction :eqrr, r[a] == r[b] ? 1 : 0

input = File.read("#{__DIR__}/input.txt").chomp
lines = input.lines

total = 0

i = 0
while i < lines.size
  line = lines[i]
  i += 1
  next if line.empty?

  match = line.match(/Before:\s*\[(.+)\]/)
  break unless match

  before = match[1].not_nil!.split(",").map(&.to_i)

  opcode, a, b, c = lines[i].split.map(&.to_i)
  i += 1

  line = lines[i]
  i += 1

  match = line.match(/After:\s*\[(.+)\]/).not_nil!
  after = match[1].not_nil!.split(",").map(&.to_i)

  count = Instruction::ALL.count do |instr|
    registers = before.dup
    instr.execute(a, b, c, registers)
    registers == after
  end
  total += 1 if count >= 3
end

puts total
