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

lines = File.readlines('./day11.input', chomp: true)

rows_empty = T.let((0..(lines.length - 1)).to_a, T::Array[Integer])
cols_empty = T.let((0..(T.must(lines[0]).length - 1)).to_a, T::Array[Integer])

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
    cols_empty: T::Array[Integer],
    expansion_factor: Integer
  ).returns(Integer)
end
def distance(g1, g2, rows_empty, cols_empty, expansion_factor: 2)
  x_min = [g1.x, g2.x].min
  x_max = [g1.x, g2.x].max
  y_min = [g1.y, g2.y].min
  y_max = [g1.y, g2.y].max

  empty_rows_on_route = rows_empty.filter { |y| y.between?(y_min, y_max) }.length
  empty_cols_on_route = cols_empty.filter { |x| x.between?(x_min, x_max) }.length

  row_extension = (empty_rows_on_route * expansion_factor) - empty_rows_on_route
  cols_extension = (empty_cols_on_route * expansion_factor) - empty_cols_on_route

  reg_dist = (g1.x - g2.x).abs + (g1.y - g2.y).abs
  reg_dist + row_extension + cols_extension
end

pp 'G:', galaxies
# pp 'rows:', rows_empty
# pp 'cols', cols_empty

# g1 = T.must galaxies[0]
# g7 = T.must galaxies[6]
# g5 = T.must galaxies[4]
# g8 = T.must galaxies[7]
# g9 = T.must galaxies[8]

# pp 'dist 1->7 (15)', distance(g1, g7, rows_empty, cols_empty)
# pp 'dist 5->9 (9)', distance(g5, g9, rows_empty, cols_empty)
# pp 'dist 8->9 (5)', distance(g8, g9, rows_empty, cols_empty)

sig do
  params(
    pairs: T::Set[T::Set[Galaxy]],
    rows_empty: T::Array[Integer],
    cols_empty: T::Array[Integer]
  ).void
end
def d11p1(pairs, rows_empty:, cols_empty:)
  pp('P1 total dist', pairs.map do |pair|
    gal1, gal2 = T.let(pair.to_a, T::Array[Galaxy])
    distance(T.must(gal1), T.must(gal2), rows_empty, cols_empty)
  end.sum(0))
end

sig do
  params(
    pairs: T::Set[T::Set[Galaxy]],
    rows_empty: T::Array[Integer],
    cols_empty: T::Array[Integer]
  ).void
end
def d11p2(pairs, rows_empty:, cols_empty:)
  pp('P2 total dist', pairs.map do |pair|
    gal1, gal2 = T.let(pair.to_a, T::Array[Galaxy])
    distance(T.must(gal1), T.must(gal2), rows_empty, cols_empty, expansion_factor: 1_000_000)
  end.sum(0))
end

d11p2(pairs, rows_empty:, cols_empty:)
