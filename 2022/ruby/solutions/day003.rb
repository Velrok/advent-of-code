# typed: strong
# frozen_string_literal: true

require 'sorbet-runtime'
require './utils'

extend T::Sig # rubocop:disable Style/MixinUsage

sig { params(file_name: String).void }
def part1(file_name) # rubocop:disable Metrics/MethodLength
  priorities = []
  File.readlines(file_name).each do |line|
    puts "line: #{line}"
    left, right = split(line)

    puts "left:  #{left}"
    puts "right: #{right}"

    dup = duplicate(left, right)
    puts "duplicate: #{dup}"

    prio = priority(dup)
    puts "prio: #{prio}"

    #  find duplicate
    #  for each duplicate:
    #    find priority
    #  sum priorities
    puts ' ' * 20

    priorities << prio
  end

  puts "result: #{priorities.sum}"
end

sig { params(line: String).returns([String, String]) }
def split(line)
  length = line.chomp.size
  split_at = length / 2
  left = T.must(line[0..(split_at - 1)])
  right = T.must(line[split_at..length - 1])
  [left, right]
end

sig { params(left: String, right: String).returns(String) }
def duplicate(left, right)
  left_set = left.split('')
  right_set = right.split('')

  common = (left_set & right_set)
  raise "found more than 1 common character: #{common}" if common.size > 1

  T.must(common.first)
end

sig { params(dup: String).returns(Integer) }
def priority(dup)
  # 1 through 26.
  lowercases = 'a'..'z'
  # 27 through 52.
  uppercases = 'A'..'Z'

  priority = lowercases.find_index(dup)&.+(1) ||
             uppercases.find_index(dup)&.+(27)

  T.must(priority)
end

sig { params(file_name: String).void }
def part2(file_name)
  line_groups = File
                .readlines(file_name)
                .map { _1.chomp }
                .map { _1.split('') }
                .map(&:to_set)
                .each_slice(3)
  result = line_groups.map do |group|
    puts "group: #{group.inspect}"
    common_one = common_character(group)
    puts "common_one: #{common_one.inspect}"
    puts ''
    priority(common_one)
  end.sum

  puts "result: #{result}"
end

sig { params(sets: T::Array[T::Set[String]]).returns(String) }
def common_character(sets)
  s1 = T.must(sets[0])
  s2 = T.must(sets[1])
  s3 = T.must(sets[2])

  common_between_all = s1 & s2 & s3

  raise "found more than 1 common charater: #{common_between_all}" unless common_between_all.length == 1

  T.must(common_between_all.first)
end

# main('problem-inputs/day003.example')
# part1('problem-inputs/day003.input')
# part2('problem-inputs/day003.example')
part2('problem-inputs/day003.input')
