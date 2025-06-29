import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  "inputs/day03"
  // "inputs/day03.example"
  |> simplifile.read()
  |> result.lazy_unwrap(fn() { panic as "cant read input file inputs/day03" })
  |> split_lines()
  |> split_chars()
  |> list.filter(fn(l) { !list.is_empty(l) })
  |> parse_chars_to_coords()
  // |> part01
  |> part02
  |> echo
}

fn part01(input) {
  input
  |> list.fold(#(#(0, 0), ""), fn(state, coords) {
    let #(pos, code) = state
    let next_pos =
      list.fold(coords, pos, fn(pos, delta) {
        let #(x, y) = pos
        let #(dx, dy) = delta

        #(
          int.clamp(x + dx, min: -1, max: 1),
          int.clamp(y + dy, min: -1, max: 1),
        )
      })
    #(next_pos, code <> pos_to_number(next_pos))
  })
}

fn part02(input) {
  input
  |> list.fold(#(#(0, 0), ""), fn(state, coords) {
    let #(pos, code) = state
    let next_pos =
      list.fold(coords, pos, fn(pos, delta) {
        let #(x, y) = pos
        let #(dx, dy) = delta

        let nx = x + dx
        let ny = y + dy

        let xlim = case y {
          -2 | 2 -> 0
          -1 | 1 -> 1
          0 -> 2
          _ -> panic
        }
        let ylim = case x {
          -2 | 2 -> 0
          -1 | 1 -> 1
          0 -> 2
          _ -> panic
        }

        #(
          int.clamp(nx, min: -xlim, max: xlim),
          int.clamp(ny, min: -ylim, max: ylim),
        )
      })
    #(next_pos, code <> pos_to_number_2(next_pos))
  })
}

fn pos_to_number(pos: #(Int, Int)) -> String {
  case pos {
    #(-1, -1) -> "1"
    #(0, -1) -> "2"
    #(1, -1) -> "3"
    #(-1, 0) -> "4"
    #(0, 0) -> "5"
    #(1, 0) -> "6"
    #(-1, 1) -> "7"
    #(0, 1) -> "8"
    #(1, 1) -> "9"
    _ -> panic as "invalid keypad position"
  }
}

fn pos_to_number_2(pos: #(Int, Int)) -> String {
  case pos {
    #(0, -2) -> "1"

    #(-1, -1) -> "2"
    #(0, -1) -> "3"
    #(1, -1) -> "4"

    #(-2, 0) -> "5"
    #(-1, 0) -> "6"
    #(0, 0) -> "7"
    #(1, 0) -> "8"
    #(2, 0) -> "9"

    #(-1, 1) -> "A"
    #(0, 1) -> "B"
    #(1, 1) -> "C"

    #(0, 2) -> "D"

    _ -> panic as "invalid keypad position"
  }
}

fn split_lines(s: String) -> List(String) {
  string.split(s, on: "\n")
}

fn split_chars(lines: List(String)) -> List(List(String)) {
  list.map(lines, fn(line) { string.split(line, on: "") })
}

fn parse_chars_to_coords(
  char_lines: List(List(String)),
) -> List(List(#(Int, Int))) {
  use line <- list.map(char_lines)
  use char <- list.map(line)
  case char {
    "U" -> #(0, -1)
    "D" -> #(0, 1)
    "L" -> #(-1, 0)
    "R" -> #(1, 0)
    _ -> panic as char
  }
}
