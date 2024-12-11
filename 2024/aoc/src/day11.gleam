import gleam/int
import gleam/io.{debug}
import gleam/list
import gleam/result
import gleam/string
import glemo
import simplifile

const blink_one_cache_id = "day11/blink_one"

const blink_cache_id = "day11/blink"

type Stones =
  List(Int)

fn split_number(n: Int) -> List(Int) {
  let ns = int.to_string(n)
  let length = string.length(ns)
  let assert Ok(start) = string.drop_end(ns, length / 2) |> int.parse()
  let assert Ok(end) = string.drop_start(ns, length / 2) |> int.parse()
  [start, end]
}

fn even_digits(n: Int) -> Bool {
  { n |> int.to_string() |> string.length() } % 2 == 0
}

// fn encode(stones: Stones) -> String {
//   stones
//   |> list.map(int.to_string)
//   |> string.join(" ")
// }

fn decode(cache_line: String) -> Stones {
  cache_line
  |> string.trim()
  |> string.split(" ")
  |> list.map(int.parse)
  |> result.values
}

fn blink_one(stone: Int) -> Stones {
  case stone, even_digits(stone) {
    0, _ -> [1]
    x, True -> split_number(x)
    x, False -> [x * 2024]
  }
}

fn blink(stones: Stones) -> Stones {
  stones
  |> list.flat_map(glemo.memo(_, blink_one_cache_id, blink_one))
}

fn times(n: Int, agg, f) {
  debug(n)
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

// idea: Do a deepth first search bottoming out at given level with a memo on blink, so that we an cache whole sub trees
fn part02(stones: Stones) {
  // times(40, stones, blink)
  times(40, stones, glemo.memo(_, blink_cache_id, blink))
  |> list.length()
  |> debug
}

pub fn main() {
  glemo.init([blink_one_cache_id, blink_cache_id])
  let example = "125 17"
  let assert Ok(input) = simplifile.read("inputs/day11.input")

  let stones: Stones = decode(input)
  part02(stones)
}
// for 33 not 75
// gleam run -m day11  3.91s user 0.49s system 106% cpu 4.152 total

// with blink_one memoisation
// gleam run -m day11  2.73s user 1.14s system 38% cpu 10.123 total

// for 40
// 98104984
// gleam run -m day11  31.34s user 13.25s system 88% cpu 50.274 total

// using recurrsion
// 98104984
// gleam run -m day11  79.36s user 11.77s system 97% cpu 1:33.65 total

// using caching on the blink fn
// 98104984
// gleam run -m day11  34.89s user 17.56s system 88% cpu 59.217 total
