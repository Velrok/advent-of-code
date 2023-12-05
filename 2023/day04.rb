# frozen_string_literal: true
# typed: true

require 'sorbet-runtime'
require 'sorbet-struct-comparable'

extend T::Sig

class Card < T::Struct
  extend T::Sig

  const :card_no, Integer
  const :winning, Set
  const :drawn, T::Array[Integer]


  sig { params(str: String).returns(Card) }
  def self.from_string(str)
    pattern = /Card +(?<card_no>\d+):+(?<winning>( +\d+)+).*\|(?<drawn>( +\d+)+)/
    pattern.match(str) => { card_no:, winning:, drawn: }
    Card.new(
      card_no: card_no.to_i,
      winning: winning.split.map(&:to_i).to_set,
      drawn: drawn.split.map(&:to_i)
    )
  end

  sig { returns(Numeric) }
  def points
    matches = drawn
      .select { winning.include?(_1) }
      .length

    matches > 0 ? 2**(matches-1) : 0
  end
end

cards = File
  .readlines('./day04.input', chomp: true)
  .map { Card.from_string(_1) }

sig { params(cards: T::Array[Card]).returns(Numeric) }
def part1(cards)
  cards
    .map(&:points)
    .sum
end

puts "--- Day 4 ---"
pp part1(cards)
puts "-------------"
