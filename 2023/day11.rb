# frozen_string_literal: true
# typed: strong

require 'sorbet-runtime'
require 'sorbet-struct-comparable'
require 'pry'

extend T::Sig

class Galaxy < T::Struct
  extend T::Sig
  include T::Struct::ActsAsComparable

  const :x, Integer
  const :y, Integer
  const :id, Integer
end

galaxies = T.let([], T::Array[Galaxy])

lines = File.readlines('./day11.example', chomp: true)

rows_empty = T.let((0..lines.length).to_a, T::Array[Integer])
cols_empty = T.let((0..T.must(lines[0]).length).to_a, T::Array[Integer])

lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    next unless char == '#'

    galaxies << Galaxy.new(x:, y:, id: galaxies.size + 1)
    rows_empty.delete(y)
    cols_empty.delete(x)
  end
end

pairs = galaxies.product(galaxies).map do |g1, g2|
  next if g1 == g2

  [g1, g2].to_set
end.compact.to_set

sig do
  params(
    g1: Galaxy,
    g2: Galaxy,
    rows_empty: T::Array[Integer],
    cols_empty: T::Array[Integer]
  ).returns(Integer)
end
def distance(g1, g2, rows_empty, cols_empty)
  x_min = [g1.x, g2.x].min
  x_max = [g1.x, g2.x].max
  y_min = [g1.y, g2.y].min
  y_max = [g1.y, g2.y].max
  row_extension = rows_empty.filter { |y| y.between?(y_min, y_max) }.length
  cols_extension = cols_empty.filter { |x| x.between?(x_min, x_max) }.length
  (g1.x - g2.x).abs + (g1.y - g2.y).abs + row_extension + cols_extension
end

pp 'G:', galaxies
# pp 'rows:', rows_taken
# pp 'cols', cols_taken
# g5 = T.must galaxies[4]
# g9 = T.must galaxies[8]
# pp distance(g5, g9, rows_empty, cols_empty)
pp pairs.map { |pair|
  g1, g2 = pair.to_a
  dist = distance(T.must(g1), T.must(g2), rows_empty, cols_empty)
  pp g1, g2, dist
  dist
}.sum(0)
