import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import simplifile

pub fn lines(filename from: String) {
  let assert Ok(puzzle_input) = simplifile.read(from: from)
  string.split(puzzle_input, on: "\n")
  |> list.filter(fn(line) { line != "" })
}

pub fn index_of(haystack: String, needle: String) -> Result(Int, Nil) {
  string.split(haystack, "")
  |> list.window(string.length(needle))
  |> list.index_map(fn(chars, index) {
    case string.join(chars, with: "") == needle {
      False -> None
      True -> Some(index)
    }
  })
  |> option.values
  |> list.first
}
