# frozen_string_literal: true
# typed: false

require 'sorbet-runtime'
require 'sorbet-struct-comparable'

class Hand < T::Struct
  extend T::Sig

  class Card < T::Struct
    extend T::Sig

    const :name, String

    sig { params(other: Card).returns(Integer) }
    def <=>(other)
      value <=> other.value
    end

    sig { returns(Integer) }
    def value
      T.must(%w[2 3 4 5 6 7 8 9 T J Q K A].index(name)) + 1
    end
  end

  class Type < T::Enum
    extend T::Sig

    enums do
      FiveOfAKind = new
      FourOfAKind = new
      FullHouse = new
      ThreeOfAKind = new
      TwoPair = new
      OnePair = new
      HighCard = new
    end

    def order
      [
        HighCard,
        OnePair,
        TwoPair,
        ThreeOfAKind,
        FullHouse,
        FourOfAKind,
        FiveOfAKind,
      ]
    end

    sig { params(other: T.untyped).returns(Integer) }
    def <=>(other)
      order.index(self) <=> order.index(other)
    end
  end

  const :cards, T::Array[Card]
  const :bid, Numeric

  sig { returns(Hand::Type) }
  def type
    case cards.group_by(&:name).values.map(&:size).select { |x| x > 1 }.sort.reverse
    in [5]
      Type::FiveOfAKind
    in [4]
      Type::FourOfAKind
    in [3]
      Type::ThreeOfAKind
    in [3, 2]
      Type::FullHouse
    in [2]
      Type::OnePair
    in [2,2]
      Type::TwoPair
    else
      Type::HighCard
    end
  end

  sig { params(other: Hand).returns(Integer) }
  def <=>(other)
    cmp = type <=> other.type
    if cmp == 0
      cards.zip(other.cards).each do |a, b|
        cmp = a <=> T.must(b)
        return cmp if cmp != 0
      end
    else
      cmp
    end
  end
end

hands = File.readlines('./day07.input', chomp: true)
  .map do |line|
    cards_str, bid_str = line.split(" ")
    Hand.new(
      cards: T.must(cards_str).split("").map { Hand::Card.new(name: _1)},
      bid: bid_str.to_i
    )
  end

pp hands.sort.each_with_index.map { |hand, i| hand.bid * (i + 1)}.sum
