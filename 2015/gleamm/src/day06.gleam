import gleam/io.{debug}
import gleam/option.{None, Some}
import matrix

fn part1() {
  todo
}

fn part2() {
  todo
}

fn matrix_test() {
  let m = matrix.new(width: 5, height: 3, default: False)
  m
  |> matrix.upsert(x: 0, y: 0, with: fn(maybe_bool) {
    case maybe_bool {
      Some(b) -> !b
      None -> panic
    }
  })
}

// gleam run -m day01
pub fn main() {
  debug(matrix_test())
  // debug(part1())
  // debug(part2())
}
