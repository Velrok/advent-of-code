import gleam/result
import gleam/string
import simplifile

pub fn main() {
  echo "Day 6: Probably a light switch problem"
  //asdf

  let input =
    simplifile.read("inputs/day06")
    |> result.lazy_unwrap(fn() { panic as "Failed to read input" })
    |> string.trim
    |> string.split("\n")
  echo input
}
