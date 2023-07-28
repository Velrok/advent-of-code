# frozen_string_literal: true
# typed: strong

require 'sorbet-runtime'

extend T::Sig # rubocop:disable Style/MixinUsage
extend T::Generic # rubocop:disable Style/MixinUsage

sig do
  type_parameters(:U)
    .params(
      lines: T::Array[T.type_parameter(:U)]
    ).returns(T::Array[T::Array[T.type_parameter(:U)]])
end
def line_groups(lines)
  groups = [[]]
  lines.each do |line|
    if ['', "\n"].include?(line)
      groups << []
    else
      groups.last << line
    end
  end
  groups
end
