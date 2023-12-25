# frozen_string_literal: true
# typed: strong

require 'sorbet-runtime'
require 'sorbet-struct-comparable'
require 'pry';

extend T::Sig

class PipeModel < T::Enum
  enums do
    Ground = new(".")
    Vertical = new("|")
    Horizontal = new("-")
    NE = new("L")
    NW = new("J")
    SE = new("F")
    SW = new("7")
    Start = new("S")
  end
end

class Pos < T::Struct
  extend T::Sig
  include T::Struct::ActsAsComparable

  const :x, Integer
  const :y, Integer

  sig { returns(Pos) }
  def north = Pos.new(x:, y: y - 1)

  sig { returns(Pos) }
  def south = Pos.new(x:, y: y + 1)

  sig { returns(Pos) }
  def east = Pos.new(x: x + 1, y:)

  sig { returns(Pos) }
  def west = Pos.new(x: x - 1, y:)
end

class Pipe < T::Struct
  extend T::Sig
  include T::Struct::ActsAsComparable

  const :pos, Pos
  const :model, PipeModel

  sig { params(other: Pipe).returns(T::Boolean) }
  def connected?(other)
    connections.intersection(other.connections).any?
  end

  sig { returns(T::Array[Pos]) }
  def connections
    case model
    when PipeModel::Ground
      []
    when PipeModel::Vertical
      [pos.north, pos.south]
    when PipeModel::Horizontal
      [pos.east, pos.west]
    when PipeModel::NE
      [pos.north, pos.east]
    when PipeModel::NW
      [pos.north, pos.west]
    when PipeModel::SE
      [pos.south, pos.east]
    when PipeModel::SW
      [pos.south, pos.west]
    when PipeModel::Start
      [
        pos.north,
        pos.north.east,
        pos.east,
        pos.south.east,
        pos.south,
        pos.south.west,
        pos.west,
        pos.north.west,
      ]
    end
  end

  sig { params(from: Pos).returns(T::Array[Pos]) }
  def follow(from)
    # warn "Following #{from.pretty_inspect} connections #{connections.pretty_inspect}"
    dest = connections.reject { |pos| pos == from }
    # warn "dest: #{dest.pretty_inspect}"
    dest
  end
end


class Field < T::Struct
  extend T::Sig

  const :w, Integer
  const :h, Integer

  const :field, T::Array[T::Array[Pipe]]
  const :start, Pipe

  sig { params(pos: Pos).returns(Pipe) }
  def pipe_at(pos)
    T.must(T.must(field[pos.y])[pos.x])
  end

  sig { returns([Pipe, Pipe]) }
  def start_connections
    pipe = start
    a, b = pipe
      .connections
      .map { |pos| pipe_at(pos) }
      .select { |neighbour_pipe| neighbour_pipe.connections.include?(pipe.pos) }
    [T.must(a), T.must(b)]
  end
end

sig { params(lines: T::Array[String]).returns(Field) }
def field_from_lines(lines)
  start = T.let(nil, T.nilable(Pipe))
  field = lines.each_with_index.map do |line, y|
    line
      .split("")
      .each_with_index
      .map do |char, x|
        model = PipeModel.deserialize(char)
        pos = Pos.new(x: x, y: y)
        pipe = Pipe.new(pos:, model:)
        start = pipe if model == PipeModel::Start
        pipe
      end
  end

  Field.new(
    w: T.must(lines.first).length,
    h: lines.length,
    field:,
    start: T.must(start)
  )
end

sig { params(from: Pipe, way: Pipe, field: Field).returns(Pipe) }
def f_follow(from, way, field)
  field.pipe_at(
    T.must(
      way.connections
        .reject{ |pos| pos == from.pos }
        .first
    )
  )
end

sig { params(field: Field).void }
def d10p1(field)
  a_origin = field.start.pos
  b_origin = a_origin
  a_pipe, b_pipe = field.start_connections
  steps = 1

  loop do
    a_next = field.pipe_at(T.must(a_pipe.follow(a_origin).first))
    b_next = field.pipe_at(T.must(b_pipe.follow(b_origin).first))
    steps += 1

    # warn "#{steps}A: #{a_pipe.pretty_inspect} B: #{b_pipe.pretty_inspect}"

    break if a_next == b_next || steps > 100_000

    a_origin = a_pipe.pos
    b_origin = b_pipe.pos
    a_pipe = a_next
    b_pipe = b_next
  end

  warn "Steps: #{steps}"
end

def d10p2(field)
  a_origin = field.start.pos
  b_origin = a_origin
  a_pipe, b_pipe = field.start_connections
  steps = 1

  loop do
    a_next = field.pipe_at(T.must(a_pipe.follow(a_origin).first))
    b_next = field.pipe_at(T.must(b_pipe.follow(b_origin).first))
    steps += 1

    # warn "#{steps}A: #{a_pipe.pretty_inspect} B: #{b_pipe.pretty_inspect}"

    break if a_next == b_next || steps > 100_000

    a_origin = a_pipe.pos
    b_origin = b_pipe.pos
    a_pipe = a_next
    b_pipe = b_next
  end

  warn "Steps: #{steps}"
end

lines = File.readlines('./day10.input', chomp: true)
field = field_from_lines(lines)

# d10p1(field)
d10p2(field)
