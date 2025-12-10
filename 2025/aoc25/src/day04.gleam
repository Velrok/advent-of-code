import gleam/list
import gleam/option.{None, Some}
import gleam/set
import gleam/string
import utils.{lines, panic_on_error}
import vec/vec2.{type Vec2}

type Roll =
  Vec2(Int)

pub fn main() {
  let lines =
    "inputs/day04.example"
    |> lines

  let height = list.length(lines)
  let width =
    lines
    |> list.first()
    |> panic_on_error("file may not be empty")
    |> string.length()

  let rolls =
    lines
    |> parse_rolls
    |> set.to_list()
    |> list.count(fn(roll) { adjacent_rolls_count(roll, width, height) < 4 })
}

fn adjacent_rolls_count(roll: Roll, width: Int, height: Int) -> Int {
  {
    use dy <- list.map(list.range(-1, 1))
    use dx <- list.map(list.range(-1, 1))
    vec2.from_tuple(#(dx, dy))
  }
  |> list.flatten()
  |> list.filter(fn(v) { v != vec2.from_tuple(#(0, 0)) })
}

fn parse_rolls(lines: List(String)) -> set.Set(Vec2(Int)) {
  {
    use line, y <- list.index_map(lines)
    use char, x <- list.index_map(string.to_graphemes(line))

    case char {
      "@" -> Some(vec2.from_tuple(#(x, y)))
      _ -> None
    }
  }
  |> list.flatten()
  |> option.values()
  |> set.from_list()
}
