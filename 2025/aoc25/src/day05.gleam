import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

type Range {
  Range(from: Int, to: Int)
}

pub fn main() {
  let #(ranges_str, ingrdience_str) =
    simplifile.read("inputs/day05")
    |> panic_on_error("cant read file")
    |> string.split_once("\n\n")
    |> panic_on_error("cant find two newlines to split on")

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
    |> list.map(panic_on_error(_, "Cant parse ingredient"))

  echo ingrdience
    |> list.count(fn(ingredient) { within_ranges(ranges, ingredient) })
}

fn within_ranges(ranges: List(Range), ingredient: Int) -> Bool {
  list.any(ranges, fn(range) { includes(range, ingredient) })
}

fn parse_range(str: String) -> Range {
  let #(left, right) =
    str
    |> string.split_once("-")
    |> panic_on_error("Cant find - in " <> str)

  Range(
    from: int.parse(left) |> panic_on_error("left is not an int: " <> left),
    to: int.parse(right) |> panic_on_error("right in not an int:" <> right),
  )
}

fn panic_on_error(result: Result(a, b), msg: String) -> a {
  result.lazy_unwrap(result, fn() { panic as msg })
}

fn includes(range: Range, number: Int) -> Bool {
  number >= range.from && number <= range.to
}
