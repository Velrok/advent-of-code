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

  echo part1(ranges, ingrdience)
  echo part2(ranges)
}

fn part2(ranges: List(Range)) -> Int {
  let assert [first, ..rest] =
    list.sort(ranges, fn(r1, r2) { int.compare(r1.from, r2.from) })

  let unified =
    list.fold(rest, [first], fn(ranges, next_range) {
      let assert [current, ..others] = ranges
      case merge(current, next_range) {
        Error(_) -> [next_range, current, ..others]
        Ok(combined) -> [combined, ..others]
      }
    })
  unified
  |> list.map(length)
  |> list.reduce(int.add)
  |> panic_on_error("unified list of ranges was empty")
}

fn length(r: Range) -> Int {
  r.to - r.from + 1
  // because we are inclusive on both sides
}

fn merge(r1: Range, r2: Range) -> Result(Range, String) {
  let overlap = includes(r1, r2.from) || includes(r1, r2.to)
  case overlap {
    True ->
      Ok(Range(from: int.min(r1.from, r2.from), to: int.max(r1.to, r2.to)))
    False -> Error("dont overlap")
  }
}

fn part1(ranges: List(Range), ingrdience: List(Int)) -> Int {
  ingrdience
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
