# frozen_string_literal: true
# typed: true

require 'sorbet-runtime'
require 'sorbet-struct-comparable'

class Hand < T::Struct
  extend T::Sig

  class Card < T::Struct
    extend T::Sig

    const :name, String

    NAMES = T.let(%w[J 2 3 4 5 6 7 8 9 T Q K A].freeze, T::Array[String])
    ALL = NAMES.reject{ _1 == "J"}.map { new(name: _1) }

    sig { params(other: Card).returns(Integer) }
    def <=>(other)
      # warn "Card #{name} <=> #{other.name}"
      value <=> other.value
    end

    sig { returns(Integer) }
    def value
      @value ||= T.must(NAMES.index(name)) + 1
    end

    def joker?
      @joker ||= (name == "J")
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

    sig { params(other: T.untyped).returns(Integer) }
    def <=>(other)
      TYPE_ORDER.index(self) <=> TYPE_ORDER.index(other)
    end
  end

  TYPE_ORDER = [
    Type::HighCard,
    Type::OnePair,
    Type::TwoPair,
    Type::ThreeOfAKind,
    Type::FullHouse,
    Type::FourOfAKind,
    Type::FiveOfAKind,
  ].freeze

  const :cards, T::Array[Card]
  const :bid, Numeric

  sig { returns(T::Array[Hand]) }
  def possible_hands
    # warn "possible_hands #{bid} #{cards}"
    backlog = T.let([self], T::Array[Hand])
    base_cards = cards.reject(&:joker?).uniq
    base_cards = Card::ALL if base_cards.empty?
    hands = T.let([], T::Array[Hand])

    while hand = backlog.shift
      if hand.joker_free?
        hands << hand
      else
        i = T.must(hand.cards.index(&:joker?))
        before = hand.cards.take(i)
        after = hand.cards.drop(i + 1)

        base_cards.each do |card|
          new_cards = before + [Card.new(name: card.name)] + after
          raise "Invalid Hand" if new_cards.size != 5
          new_hand = Hand.new(
            cards: new_cards,
            bid: bid
          )
          backlog << new_hand
        end
      end
    end

    hands
  end

  def joker_free?
    @joker_free ||= cards.none?(&:joker?)
  end

  sig { returns(Hand::Type) }
  def type
    @type ||= case cards
      .group_by(&:name)
      .values
      .map(&:size)
      .select { |x| x > 1 }
      .sort
      .reverse
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

  sig { returns(Hand::Type) }
  def joker_free_type
    @joker_free_type ||= T.must(possible_hands.map(&:type).max)
    # warn "#{object_id} \t#{type} -> #{@joker_free_type }"
    @joker_free_type
  end

  sig { params(other: Hand).returns(Integer) }
  def <=>(other)
    # warn "Hand #{bid} <=> #{other.bid}"
    cmp = (joker_free_type <=> other.joker_free_type)
    if cmp == 0
      cards.zip(other.cards).each do |a, b|
        cmp = a <=> T.must(b)
        return cmp if cmp != 0
      end
      raise "Hands are equal"
    else
      cmp
    end
  end
end

lines = File.readlines('./day07.input', chomp: true)
lines_count = lines.count
hands = lines
  .each_with_index
  .map do |line, line_no|
    cards_str, bid_str = line.split(" ")
    Hand.new(
      cards: T.must(cards_str).split("").map { Hand::Card.new(name: _1)},
      bid: bid_str.to_i
    )
  end

pp(hands
  .lazy
  .sort
  .each_with_index
  .map do |hand, i|
    # warn "#{i}/#{lines_count}"
    hand.bid * (i + 1)
  end
  .sum
)
