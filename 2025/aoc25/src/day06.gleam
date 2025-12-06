import gleam/list
import gleam/string
import simplifile
import utils.{panic_on_error}

pub fn main() {
  let input =
    simplifile.read("inputs/day06")
    |> panic_on_error("cant read input file")

  input
  |> string.trim_end()
  |> string.split("\n")
}
