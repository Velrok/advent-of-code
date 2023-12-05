# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'
require 'sorbet-struct-comparable'

extend T::Sig


class Position < T::Struct
  extend T::Sig
  include T::Struct::ActsAsComparable

  prop :y, Integer
  prop :x, Integer

  sig { params(other: BasicObject).returns(T.nilable(Integer)) }
  def <=>(other)
    other = T.cast(other, Position)
    if y == other.y
      x <=> other.x
    else
      y <=> other.y
    end
  end
end

class Schematic < T::Struct
  extend T::Sig

  const :data, T::Array[T::Array[String]]

  sig { returns(Integer) }
  def w
    T.must(data.first).length
  end

  sig { returns(Integer) }
  def h
    data.length
  end

  sig { params(position: Position).returns(T::Array[Position]) }
  def digits(position)
    return [] unless digit?(position)
    found = [position]
    # leftward
    leftward = (1..w).lazy
      .map { Position.new(x: position.x - _1, y: position.y)}
      .take_while { includes?(_1) && digit?(_1) }
      .to_a
    rightward = (1..w).lazy
      .map { Position.new(x: position.x + _1, y: position.y)}
      .take_while { includes?(_1) && digit?(_1) }
      .to_a

  (leftward + found + rightward)
    .uniq
    .sort
  end

  sig { params(position: Position).returns(T::Boolean) }
  def digit?(position)
    !(/\d/.match(self[position]).nil?)
  end


  sig { params(position: Position).returns(T::Boolean) }
  def includes?(position)
    position.x >= 0 && position.x < w && position.y >= 0 && position.y < h
  end

  sig { params(position: Position).returns(T::Array[Position]) }
  def neighbours(position)
    [
      # left side
      Position.new(x: position.x - 1, y: position.y - 1),
      Position.new(x: position.x - 1, y: position.y),
      Position.new(x: position.x - 1, y: position.y + 1),
      # right  side
      Position.new(x: position.x + 1, y: position.y - 1),
      Position.new(x: position.x + 1, y: position.y),
      Position.new(x: position.x + 1, y: position.y + 1),
      # top
      Position.new(x: position.x, y: position.y - 1),
      # bottom
      Position.new(x: position.x, y: position.y + 1),
    ].select do |position|
        includes?(position)
      end
  end

  sig { returns(T::Array[Position]) }
  def positions
    (0..h-1).flat_map do |y|
      (0..w-1).map do |x|
        Position.new(x: x, y: y)
      end
    end
  end

  sig { params(position: Position).returns(String) }
  def [](position)
    T.must(T.must(data[position.y])[position.x])
  end
end

input = File
  .readlines('./day03.input', chomp: true)
  .map { |line| line.split('') }

schematic = Schematic.new(data: input)

sig { params(schematic: Schematic).returns(T.untyped) }
def part1(schematic)
  pattern = /[\d\.]/
  schematic
    .positions
    .select { |position| pattern.match(schematic[position]).nil? } # symbol positions
    .flat_map { |position| schematic.neighbours(position) }
    .uniq
    .select { schematic.digit?(_1) }
    .map { schematic.digits(_1) }
    .uniq
    .map { |digits| digits.map { |position| schematic[position] }.join.to_i }
    .sum
end

p part1(schematic)
