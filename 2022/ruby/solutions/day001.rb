# frozen_string_literal: true
# typed: strong

require 'sorbet-runtime'
require './utils'

extend T::Sig # rubocop:disable Style/MixinUsage

sig { params(file_name: String).void }
def main(file_name)
  lines = File.readlines(file_name)
  number_groups = line_groups(lines).map do |group|
    group.map(&:to_i)
  end
  group_sums = number_groups.map do |group|
    group.sum(0)
  end
  # puts group_sums.max # part 1
  puts group_sums.sort.reverse.take(3).sum(0)
end

main('problem-inputs/day001.input')
