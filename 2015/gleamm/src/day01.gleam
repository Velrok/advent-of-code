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
    list.fold(over: chars, from: #(0, 0), with: fn(state, el) {
      let #(pos, current_floor) = state
      case current_floor {
        -1 -> state
        _ ->
          case el {
            "(" -> #(pos + 1, current_floor + 1)
            ")" -> #(pos + 1, current_floor - 1)
            _ -> panic
          }
      }
    })

  io.debug(result)
  // io.println(puzzle_input)
}
