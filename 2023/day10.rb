# frozen_string_literal: true
# typed: strong

require 'sorbet-runtime'
require 'sorbet-struct-comparable'

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
        pos.east,
        pos.west,
        pos.north,
        pos.south,
        pos.north.east,
        pos.north.west,
        pos.south.east,
        pos.south.west
      ]
    end
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

sig { params(field: Field).returns(T::Array[Pipe]) }
def start_connections(field)
  pipe = field.start
  pipe
    .connections
    .map { |pos| field.pipe_at(pos) }
    .select { |neighbour_pipe| neighbour_pipe.connections.include?(pipe.pos) }
end

sig { params(lines: T::Array[String]).void }
def d10p1(lines)
  field = field_from_lines(lines)
  pp start_connections(field)
end


lines = File.readlines('./day10.example', chomp: true)
d10p1(lines)
