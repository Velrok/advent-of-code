# frozen_string_literal: true
# typed: strong

require 'sorbet-runtime'
require 'sorbet-struct-comparable'

extend T::Sig


EXAMPLE = <<~EXAMPLE
3   4
4   3
2   5
1   3
3   9
3   3
EXAMPLE

def part01
  left = []
  right = []

  # lines = EXAMPLE.split("\n")
  # lines.each do |line|
  #
  File.readlines('day01.input').each do |line|
    numbers = line.split(/ +/)
    left << numbers[0].to_i
    right << numbers[1].to_i
  end

  left.sort!
  right.sort!

  result = left.zip(right).map do |l, r|
    puts "l: #{l}, r: #{r}"
    (l - r).abs
  end.sum

    puts "result: #{result}"
end

def part02
  left = []
  right = Hash.new(0)

  # lines = EXAMPLE.split("\n")
  # lines.each do |line|
  #
  File.readlines('day01.input').each do |line|
    numbers = line.split(/ +/)
    left << numbers[0].to_i

    r = numbers[1].to_i
    right[r] += 1
  end

  # left.sort!
  # right.sort!

  result = left.map do |l|
    l * right[l]
  end.sum

  puts "result: #{result}"
end

part02
