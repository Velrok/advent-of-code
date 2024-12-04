import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import simplifile

pub fn lines(filename from: String) {
  let assert Ok(puzzle_input) = simplifile.read(from: from)
  string.split(puzzle_input, on: "\n")
  |> list.filter(fn(line) { line != "" })
}

pub fn frequencies(l input: List(a)) {
  input
  |> list.fold(from: dict.new(), with: fn(freq, el) {
    dict.upsert(freq, el, fn(existing) {
      case existing {
        None -> 1
        Some(c) -> c + 1
      }
    })
  })
}
