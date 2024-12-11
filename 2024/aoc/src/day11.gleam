import gleam/int
import gleam/io.{debug}
import gleam/list
import gleam/result
import gleam/string
import simplifile

type Stones =
  List(Int)

fn split_number(n: Int) -> List(Int) {
  let ns = int.to_string(n)
  let length = string.length(ns)
  let assert Ok(start) = string.drop_end(ns, length / 2) |> int.parse()
  let assert Ok(end) = string.drop_start(ns, length / 2) |> int.parse()
  [start, end]
}

fn event_digits(n: Int) -> Bool {
  { n |> int.to_string() |> string.length() } % 2 == 0
}

fn blink(stones: Stones) -> Stones {
  // debug(stones)
  stones
  |> list.flat_map(fn(stone) {
    case stone, event_digits(stone) {
      0, _ -> [1]
      x, True -> split_number(x)
      x, False -> [x * 2024]
    }
  })
}

fn times(n: Int, agg, f) {
  case n {
    0 -> agg
    _ -> times(n - 1, f(agg), f)
  }
}

fn part01(stones: Stones) {
  times(25, stones, blink)
  |> list.length()
  |> debug
}

pub fn main() {
  let example = "125 17"
  let assert Ok(input) = simplifile.read("inputs/day11.input")

  let stones: Stones =
    input
    |> string.trim()
    |> string.split(" ")
    |> list.map(int.parse)
    |> result.values
  part01(stones)
}
