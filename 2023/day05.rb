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

      const :source, T::Range[Numeric]
      const :destination, T::Range[Numeric]
    end

    const :from, String
    const :to, String
    const :ranges, T::Array[Map::Range]

    def lookup(source)
      T.must(ranges.find { |r| r.source.include?(source) }).destination.begin + (source - T.must(ranges.find { |r| r.source.include?(source) }).source.begin)
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
          m = /(?<from>\w+)-to-(?<to>\w+) map:/.match(line)
          m => {from:, to:}

          ranges = T.must(lines[index+1..]).lazy
            .take_while { _1 != "" }
            .map do |line|
              dest, source, length = T.cast(line.split(" ").map(&:to_i), [Numeric, Numeric, Numeric])
              Map::Range.new(source: source..(source + length), destination: dest..(dest + length))
            end.to_a
          pp [line, index, from , to, ranges]
          Map.new(from:, to:, ranges:)
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
        next_id = mapper.lookup(next_id)
      end
    end
  end

  sig { params(almanac: Almanac).void }
  def part1(almanac)
  end
end


lines = File
  .readlines('./day05.example', chomp: true)

almanc = Day05::Almanac.from_strings(lines)

puts "--> #{__FILE__}"
pp almanc
puts "done"
