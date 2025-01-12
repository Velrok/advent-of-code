# frozen_string_literal: true
# typed: strong

require 'pp'

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
