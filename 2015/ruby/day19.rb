# typed: strict

require 'sorbet-runtime'
extend T::Sig

Medicine = T.type_alias { String }
Replacements = T.type_alias { T::Hash[String, T::Array[String]] }

sig { params(input: String).returns([Medicine, Replacements]) }
def parse(input)
  lines = input.split("\n")
  replacements = T.must(lines[0..-3])
    .map { |line| line.split(' => ') }
    .reduce(T.let({}, Replacements)) do |agg, kv|

      from = T.must(kv[0])
      to = T.must(kv[1])

      if agg.include?(from)
        T.must(agg[from]) << to
      else
        agg[from] = [to]
      end

      agg
    end

  [T.must(lines.last), replacements ]
end

sig { params(medicine: Medicine, replacements: Replacements).returns(T::Enumerable[String]) }
def possible_replacements(medicine, replacements)
  results = T.let([], T::Array[String])
  replacements.each do |key, values|
    starting_position = 0
    while match = medicine.index(key, starting_position) do
      match_length = key.length
      values.each do |value|
        medicine_copy = medicine.dup
        medicine_copy[match..(match_length + match - 1)] = value
        results << medicine_copy
      end
      starting_position = match + 1
    end
  end
  results.uniq
end

sig { void }
def part1
  input = File.read('inputs/day19')
  medicine, replacements = parse(input)

  puts possible_replacements(medicine, replacements).count
end

part1
