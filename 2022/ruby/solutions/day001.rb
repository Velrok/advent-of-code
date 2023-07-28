# frozen_string_literal: true
# typed: strong

require 'sorbet-runtime'
require './utils'

extend T::Sig # rubocop:disable Style/MixinUsage

sig { params(file_name: String).void }
def main(file_name)
  elfs = line_groups(File.readlines(file_name))
         .map { |group| group.map(&:to_i) }
         .map { |group| group.sum(0) }
  # puts elfs.max # part 1
  puts elfs.sort.reverse.take(3).sum(0)
end

main('problem-inputs/day001.input')
