import simplifile
import gleam/string

pub fn lines(filename from: String) {
  let assert Ok(puzzle_input) = simplifile.read(from: from)
  string.split(puzzle_input, on: "\n")
}
