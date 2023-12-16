# frozen_string_literal: true
# typed: true

require 'sorbet-runtime'
require 'sorbet-struct-comparable'

lines = File.readlines('./day06.input', chomp: true)

class Race < T::Struct
  extend T::Sig

  const :time, Numeric
  const :distance, Numeric

  sig { returns([Numeric, Numeric]) }
  def solve
    solutions = (1..(time))
    [
      find_lower_bound(solutions),
      find_upper_bound(solutions)
    ]
  end

  def winner?(speed)
    speed * (time - speed) > distance
  end

  def find_lower_bound(solutions)
    left = solutions.take(solutions.size / 2)
    case left.size
    when 1
      left.last + 1
    else
      if winner?(left.last)
        find_lower_bound(solutions.take(solutions.size / 2))
      else
        find_lower_bound(solutions.drop(solutions.size / 2))

      end
    end
  end

  def find_upper_bound(solutions)
    right = solutions.drop(solutions.size / 2)
    case right.size
    when 1
      right.first
    else
      if winner?(right.first)
        find_upper_bound(solutions.drop(solutions.size / 2))
      else
        find_upper_bound(solutions.take(solutions.size / 2))

      end
    end
  end
end

def p1(lines)
  times = T.must(lines[0]&.split(':')&.last&.split(" ")&.map(&:to_i))
  distances = T.must(lines[1]&.split(':')&.last&.split(" ")&.map(&:to_i))
  races = times.zip(distances).map { |time, distance| Race.new(time:, distance: T.must(distance)) }

  pp races
  pp(races
    .map(&:solve)
    .map do |x|
      pp x
      from, to = x
      (to - from) + 1
    end
    .inject(1) {|agg, e| agg * e}
  )
end

def p2(lines)
  time = T.must(lines[0]&.split(':')&.last&.gsub(" ", '')&.to_i)
  distance = T.must(lines[1]&.split(':')&.last&.gsub(" ", '')&.to_i)
  race = Race.new(time:, distance: T.must(distance))

  pp race
  low, high = race.solve
  pp high - low - 1
end

p2(lines)
