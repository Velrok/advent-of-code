import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

// |> simplifile.read()

pub fn main() {
  "inputs/day03"
  |> parse()
  |> part02()
  |> list.length()
  |> echo
}

pub fn part01(l) {
  list.filter(l, valid_triangle)
}

pub fn part02(triples_list: List(List(Int))) {
  triples_list
  |> list.sized_chunk(3)
  |> list.flat_map(fn(group) { list.transpose(group) })
  |> list.filter(valid_triangle)
}

fn parse(filename) {
  filename
  |> simplifile.read()
  |> result.lazy_unwrap(fn() { panic as "cant read inputs/day03" })
  |> string.split(on: "\n")
  |> list.map(string.trim)
  |> list.map(fn(line) { line |> string.split(on: " ") })
  |> list.map(fn(numbers_maybe) {
    numbers_maybe |> list.filter(fn(n) { !string.is_empty(n) })
  })
  |> list.map(fn(number_strings) {
    number_strings
    |> list.map(fn(ns) {
      case ns |> int.parse() {
        Error(_) -> {
          let msg = "cant parse " <> ns
          panic as msg
        }
        Ok(n) -> n
      }
    })
  })
  |> list.filter(fn(l) { !list.is_empty(l) })
}

fn valid_triangle(sides: List(Int)) -> Bool {
  case sides {
    [a, b, c] -> {
      a + b > c && b + c > a && a + c > b
    }
    _ -> {
      echo sides
      panic as "need exactly 3 sides"
    }
  }
}
