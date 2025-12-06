import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let #(ranges_str, ingrdience_str) =
    simplifile.read("inputs/day05.example")
    |> result.lazy_unwrap(fn() { panic })
    |> string.split_once("\n\n")
    |> result.lazy_unwrap(fn() { panic })

  let ranges =
    ranges_str
    |> string.trim_end()
    |> string.split("\n")
    |> list.map(parse_range)

  let ingrdience =
    ingrdience_str
    |> string.trim_end()
    |> string.split("\n")
    |> list.map(int.parse)
    |> list.map(panic_on_error(_, "Cant parse ingrdient"))

  echo ranges
  echo ingrdience
}

fn parse_range(str: String) -> List(Int) {
  let #(left, right) =
    str
    |> string.split_once("-")
    |> panic_on_error("Cant find - in " <> str)

  list.range(
    int.parse(left) |> panic_on_error("left is not an int: " <> left),
    int.parse(right) |> panic_on_error("right in not an int:" <> right),
  )
}

fn panic_on_error(result: Result(a, b), msg: String) -> a {
  result.lazy_unwrap(result, fn() { panic as msg })
}
