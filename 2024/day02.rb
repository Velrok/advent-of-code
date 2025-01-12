# frozen_string_literal: true
# typed: strong

require 'pp'

# input = File.readlines('day02.example').map do |line|
#   line.strip.split(' ').map(&:to_i)
# end
#
# def safe?(report)
#   first, second = report
#
#   direction = case first <=> second
#   when 0
#     return false
#   when -1
#     :growing
#   when 1
#     :shrinking
#   end
#
#   x = report.map.with_index do |this_datapoint, i|
#     next_datapoint = report[i + 1]
#
#     # reached the end
#     if next_datapoint.nil?
#       true
#     else
#       diff = next_datapoint - this_datapoint
#
#       case direction
#       when :shrinking
#         [-1,-2,-3].include?(diff)
#       when :growing
#         [1,2,3].include?(diff)
#       end
#     end
#   end
#
#   x.all?
# end
#
# safe_reports = input.select do |report|
#   puts "Checking #{report.inspect}"
#   safe?(report)
# end
#
# puts safe_reports.count

class Report

  def self.from_line(line)
    numbers = line.strip.split(' ').map(&:to_i)
    Report.new(numbers)
  end

  def initialize(numbers)
    @numbers = numbers
  end

  def safe?
    check_numbers?(@numbers) ||
    dampened_numbers.any? {|numbers| check_numbers?(numbers)}
  end

  def dampened_numbers
    @numbers.each_with_index.map do |_n, i|
      @numbers.dup.tap {|nn|
        nn.delete_at(i)
      }
    end
  end

  def check_numbers?(numbers)
    if increasing?(numbers)
      numbers.each_cons(2).all? do |a, b|
        b >= a + 1 && b <= a + 3
      end
    else
      numbers.each_cons(2).all? do |a, b|
        b <= a - 1 && b >= a - 3
      end
    end
  end

  def increasing?(numbers)
    numbers.first < numbers[1]
  end

end

def main
  reports = File.readlines('day02.input').map do |line|
    Report.from_line(line)
  end

  pp reports.filter(&:safe?)
    .size()
end

main
