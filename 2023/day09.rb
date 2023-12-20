# frozen_string_literal: true
# typed: true

require 'sorbet-runtime'
require 'sorbet-struct-comparable'

extend T::Sig

Series = T.type_alias { T::Array[Numeric] }

sig { params(series: Series).returns(Series) }
def derivitive(series)
  series.each_cons(2).map do |a, b|
    T.must(b) - T.must(a)
  end
end

def predict_next_number(series)
  derivitives = [derivitive(series)]

  while !derivitives.last.all?(&:zero?)
    derivitives << derivitive(derivitives.last)
  end

  derivitives.reverse.inject(0) do |acc, derivitive|
    acc + derivitive.last
  end + series.last
end


sig { params(series: Series).returns(Series) }
def derivitive_backwards(series)
  series.reverse.each_cons(2).map do |a, b|
    T.must(a) - T.must(b)
  end.reverse
end

def predict_previous_number(series)
  derivitives = [derivitive_backwards(series)]

  while !derivitives.last.all?(&:zero?)
    derivitives << derivitive_backwards(derivitives.last)
  end

  series.first - derivitives.reverse.inject(0) do |acc, derivitive|
    derivitive.first - acc
  end
end

lines = File.readlines('./day09.input', chomp: true)
series = lines.map do |line|
  line.split(" ")
    .map(&:to_i)
end

# pp predict_next_number(series.first)
# pp series.map { |s| predict_next_number(s) }.sum
# pp predict_previous_number(series.last)

pp series.map { |s| predict_previous_number(s) }.sum
# pp series[1]
