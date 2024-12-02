# frozen_string_literal: true
# typed: strong

input = File.readlines('day02.example').map do |line|
  line.strip.split(' ').map(&:to_i)
end

def safe?(report)
  first, second = report

  direction = case first <=> second
  when 0
    return false
  when -1
    :growing
  when 1
    :shrinking
  end

  x = report.map.with_index do |this_datapoint, i|
    next_datapoint = report[i + 1]

    # reached the end
    if next_datapoint.nil?
      true
    else
      diff = next_datapoint - this_datapoint

      case direction
      when :shrinking
        [-1,-2,-3].include?(diff)
      when :growing
        [1,2,3].include?(diff)
      end
    end
  end

  x.all?
end

safe_reports = input.select do |report|
  puts "Checking #{report.inspect}"
  safe?(report)
end

puts safe_reports.count
