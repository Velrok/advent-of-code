# frozen_string_literal: true
# typed: true

require 'sorbet-runtime'
require 'sorbet-struct-comparable'

class Navigation

  extend T::Sig

  sig { returns(Symbol) }
  attr_reader :position

  sig { returns(Integer) }
  attr_reader :steps

  sig { params(
    map: T::Hash[Symbol, [Symbol, Symbol]],
    position: Symbol
  ).void }
  def initialize(map:, position: :AAA)
    @position = position
    @map = map
    @steps = T.let(0, Integer)
  end

  sig { params(target_position: Symbol).returns(T::Boolean) }
  def arrived_at?(target_position = :ZZZ)
    warn "Arrived at #{position} in #{steps} steps"
    position == target_position
  end

  sig { params(instruction: Symbol).void }
  def move(instruction)
    warn "Moving #{instruction} from #{position}"
    direction = instruction == :L ? 0 : 1
    @position = T.must(T.must(@map[position])[direction])
    @steps += 1
  end

end

lines = File.readlines('./day08.input', chomp: true)
instructions = T.must(lines[0]).split('').map(&:to_sym)
pp instructions
map = lines
  .drop(2)
  .map do |line|
    from, to = line.split(' = ')
    options = T.must(to).gsub(/[()]/, '').split(', ').map(&:to_sym)
    [T.must(from).to_sym, options]
  end
  .to_h

def d8part1(map, instructions)
  navigation = Navigation.new(map: map)

  instructions
    .cycle do |instruction|
      navigation.move(instruction)
      return navigation.steps if navigation.arrived_at?
    end
end

pp d8part1(map, instructions)
