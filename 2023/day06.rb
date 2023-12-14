# frozen_string_literal: true
# typed: true

require 'sorbet-runtime'
require 'sorbet-struct-comparable'

lines = File
  .readlines('./day06.input2', chomp: true)

class Race < T::Struct
  extend T::Sig

  const :time, Numeric
  const :distance, Numeric

  sig { returns([Numeric, Numeric]) }
  def solve
    solutions = (1..(time))
      .select { |speed| speed * (time - speed) > distance }
    [T.must(solutions.first), T.must(solutions.last)]
  end
end

times = T.must(lines[0]&.split(':')&.last&.split(" ")&.map(&:to_i))
distances = T.must(lines[1]&.split(':')&.last&.split(" ")&.map(&:to_i))
races = times.zip(distances).map { |time, distance| Race.new(time:, distance:) }
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
# .map(&:*)
