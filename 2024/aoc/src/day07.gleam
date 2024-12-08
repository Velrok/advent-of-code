import gleam/string
import gleam/int
import gleam/list
import gleam/result
import gleam/option.{type Option, None, Some}
import gleam/io.{debug}
import utils

fn has_solution(test_value: Int, intermediat: Option(Int), numbers: List(Int)) {
  debug(#(test_value, intermediat, numbers))
  case numbers {
    [] -> panic
    [n] ->
      test_value == option.unwrap(intermediat, 0) + n
      || test_value == option.unwrap(intermediat, 1) * n
    [n, ..rest] ->
      has_solution(test_value, Some(option.unwrap(intermediat, 0) + n), rest)
      || has_solution(test_value, Some(option.unwrap(intermediat, 1) * n), rest)
  }
}

fn part01(lines: List(String)) {
  list.map(lines, fn(line) {
    let assert [left, right] = case string.split(line, ":") {
      [left, right] -> [left, right]
      _ -> {
        debug("Can't parse line: ")
        debug(line)
        panic
      }
    }

    let assert Ok(test_value) = int.parse(left)
    let numbers =
      right
      |> string.trim()
      |> string.split(" ")
      |> list.map(int.parse)
      |> result.values()

    case has_solution(test_value, None, numbers) {
      True -> test_value
      False -> 0
    }
  })
  |> list.reduce(int.add)
}

pub fn main() {
  let examples =
    "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"

  utils.lines("inputs/day07.input")
  |> part01()
  |> debug()
}
