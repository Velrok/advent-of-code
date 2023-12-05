# typed: strict

require 'sorbet-runtime'

extend T::Sig

class Game < T::Struct
  extend T::Sig

  class Draw < T::Struct
    extend T::Sig

    const :red, Integer, default: 0
    const :green, Integer, default: 0
    const :blue, Integer, default: 0


    sig {params(lines: T::Array[String]).returns(Draw)}
    def self.parse(lines)
      h = {}

      lines.each do |line|
        m = /(\d+) (\w+)/.match(line)
        count = m[1].to_i
        color = m[2]
        h[color.to_sym] = count
      end

      Game::Draw.new(**h)
    end

    sig { returns(Integer) }
    def power
      red * green * blue
    end
  end

  const :game_id, Integer
  const :draws, T::Array[Draw]

  sig {params(line: String).returns(Game)}
  def self.parse(line)
    m = /Game (\d+): (.*)/.match(line)

    raise "Can't parse Game string" unless m

    game_id = m[1].to_i
    draws = m[2]
      &.split(';')
      &.map(&:strip)
      &.map do |draw| draw.split(',').map(&:strip) end
      &.map do |draw| Draw.parse(draw) end
    Game.new(game_id: game_id, draws: T.must(draws))
  end

  sig { returns(Game::Draw) }
  def min_draw
    Draw.new(**{
      red: draws.map(&:red).max || 0,
      green: draws.map(&:green).max|| 0,
      blue: draws.map(&:blue).max|| 0
    })
  end
end

sig {params(games: T::Array[Game]).returns(Integer)}
def part1(games)
  games
    .select do |game|
      game.draws.all? do |draw|
        draw.red <= 12 && draw.green <= 13 && draw.blue <= 14
      end
    end
    .map(&:game_id)
    .sum
end

sig {params(games: T::Array[Game]).returns(Integer)}
def part2(games)
  games
    .map(&:min_draw)
    .map(&:power)
    .sum
end

puts ">-"
# only 12 red cubes, 13 green cubes, and 14 blue cubes
games = File
  .readlines('./day02.input1', chomp: true)
  .map do |line|
    Game.parse(line)
  end

# pp part1(games)
pp part2(games)
