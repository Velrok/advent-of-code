# frozen_string_literal: true
# typed: true

require 'sorbet-runtime'
require 'sorbet-struct-comparable'

module Day05
  extend T::Sig

  class Map < T::Struct
    extend T::Sig

    class Range < T::Struct
      extend T::Sig

      const :dest, Numeric
      const :source, Numeric
      const :length, Numeric

      sig { params(i: Numeric).returns(T::Boolean) }
      def include?(i)
        i >= source && i <= source + length
      end

      sig { params(i: Numeric).returns(Numeric) }
      def lookup(i)
        raise "Invalid source" unless self.include?(source)
        gap = dest - source
        i + gap
      end
    end
    const :from, String
    const :to, String
    const :ranges, T::Enumerable[Map::Range]

    sig { params(source: Numeric).returns(Numeric) }
    def lookup(source)
      ranges
        .find { _1.include?(source) }
        &.lookup(source) || source
    end
  end

  class Almanac < T::Struct
    extend T::Sig

    const :seeds, T::Array[Numeric]
    const :mappers, T::Array[Map] # convert to Hash indexed by source (soil, water, etc)

    sig { params(lines: T::Array[String]).returns(Almanac) }
    def self.from_strings(lines)
      raise "Invalid input" unless lines.first&.start_with?("seeds:")

      seeds = T.cast(lines.first&.split(" ")&.map(&:to_i)&.drop(1), T::Array[Numeric])

      mappers = lines.lazy
        .each_with_index
        .select { |line, index| line.include?("map:") }
        .map do |line, index|
          index = T.cast(index, Integer)
          m = /(?<from>\w+)-to-(?<to>\w+) map:/.match(line)

          ranges = T.must(lines[index+1..]).lazy
            .take_while { _1 != "" }
            .map do |line|
              dest, source, length = T.cast(line.split(" ").map(&:to_i), [Numeric, Numeric, Numeric])
              Map::Range.new(dest:, source:, length:)
            end.to_a
          Map.new(
            from: T.must(T.must(m)[:from]),
            to: T.must(T.must(m)[:to]),
            ranges:
          )
        end
        .to_a

      Almanac.new(seeds:, mappers: T.cast(mappers, T::Array[Map]))
    end

    sig { params(seed: Numeric, target_category: String).returns(Numeric) }
    def lookup_seed_location(seed, target_category: 'location')
      next_category = 'seed'
      next_id = seed
      while next_category != target_category
        mapper = T.must(mappers.find { |m| m.from == next_category})
        next_category = mapper.to
        last_id = next_id
        next_id = mapper.lookup(next_id)
        # puts "#{mapper.from} -> #{mapper.to}  #{last_id} -> #{next_id}"
      end
      next_id
    end
  end

  sig { params(almanac: Almanac).void }
  def part1(almanac)
  end
end


lines = File
  .readlines('./day05.input', chomp: true)

almanc = Day05::Almanac.from_strings(lines)

puts "--> #{__FILE__}"
# puts "part1: #{almanc.mappers.first.serialize}"
pp almanc
  .seeds
  .map { almanc.lookup_seed_location(_1) }
  .min
puts "done"
