import gleam/io
import gleam/list
import gleam/string
import utils

// gleam run -m day01
pub fn main() {
  let assert Ok(first_line) =
    utils.lines(filename: "inputs/01.p1")
    |> list.first
  let chars = string.split(first_line, on: "")
  let result =
    list.fold(over: chars, from: 0, with: fn(acc, el) {
      case el {
        "(" -> acc + 1
        ")" -> acc - 1
        _ -> panic
      }
    })

  io.debug(result)
  // io.println(puzzle_input)
}
