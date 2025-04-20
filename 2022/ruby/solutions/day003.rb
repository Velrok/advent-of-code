# typed: strong
# frozen_string_literal: true

require 'sorbet-runtime'
require './utils'

extend T::Sig # rubocop:disable Style/MixinUsage

sig { params(file_name: String).void }
def part1(file_name)
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

# main('problem-inputs/day003.example')
part1('problem-inputs/day003.input')
