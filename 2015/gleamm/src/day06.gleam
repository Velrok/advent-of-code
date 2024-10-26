import gleam/io.{debug}
import gleam/list
import gleam/string
import gleam/result
import gleam/int
import gleam/regex.{type Regex, Match}
import gleam/option.{None, Some}
import utils
import matrix
import position.{type Position}

fn parse_line(line: String, pattern: Regex) {
  todo
}

pub type Op {
  On
  Off
  Toggle
}

pub type Instruction {
  Instruction(op: Op, top_left: Position, bottom_right: Position)
}

fn interpret_results(result: List(regex.Match)) -> Instruction {
  let assert [
    Match(
      content: _,
      submatches: [Some(op), Some(p1x), Some(p1y), Some(p2x), Some(p2y)],
    ),
  ] = result
  let assert [p1x, p1y, p2x, p2y] =
    [p1x, p1y, p2x, p2y]
    |> list.map(int.parse(_))
    |> result.values

  Instruction(
    op: case op {
      "turn on" -> On
      "turn off" -> Off
      "toggle" -> Toggle
      _ -> panic
    },
    top_left: position.Position(x: p1x, y: p1y),
    bottom_right: position.Position(x: p2x, y: p2y),
  )
}

fn part1() {
  let assert Ok(pattern) =
    regex.from_string(
      "(turn on|turn off|toggle) (\\d+),(\\d+) through (\\d+),(\\d+)",
    )

  let instructions =
    utils.lines("./inputs/06.p1")
    |> list.map(regex.scan(with: pattern, content: _))
    |> list.map(interpret_results)

  let lights = matrix.new(width: 1000, height: 1000, default: False)
}

fn part2() {
  todo
}

// fn matrix_test() {
//   let m = matrix.new(width: 5, height: 3, default: False)
//   m
//   |> matrix.upsert(x: 0, y: 0, with: fn(maybe_bool) {
//     case maybe_bool {
//       Some(b) -> !b
//       None -> panic
//     }
//   })
// }

// gleam run -m day01
pub fn main() {
  // debug(matrix_test())
  debug(part1())
  // debug(part2())
}
