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
    score > 0 ? 2**(score-1) : 0
  end


  sig { returns(Numeric) }
  def score
    @score ||= drawn
      .select { winning.include?(_1) }
      .length
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

sig { params(cards: T::Array[Card]).returns(Numeric) }
def part2(cards)
  card_repo = cards.group_by(&:card_no)
  backlog = cards.clone # we start with just the first
  total_score = 0 # keep track of the total of cards we looked at

  while card = backlog.shift # take out the first card
    total_score += 1
    score = card.score # score is how many winning numbers match
    next if score == 0 # this means we win no extra cards for this one, so we move on

    # we will add score no of cards so we can add them to the total now
    # total_score += score

    # if we score one we look one more card ahead 1..1
    card_numbers = (1..score).map { |offset| card.card_no + offset }

    # puts "card: #{card.card_no} score: #{score} adds: #{card_numbers}"

    card_numbers.each do |card_no|
      # lookup the winner and add it to the backlog
      backlog << card_repo[card_no].first
    end
    # repeat until we run out of cards to look at
  end

  total_score
end


puts "--- Day 4 ---"
# pp part2(cards)
puts "-------------"
