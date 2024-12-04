import gleam/dict
import gleam/function
import gleam/int
import gleam/io.{debug}
import gleam/list
import gleam/pair
import gleam/string
import utils

fn p1() {
  utils.lines(filename: "inputs/day06.p1")
  |> list.map(fn(line) { string.split(line, on: "") })
  |> list.transpose
  |> list.map(utils.frequencies)
  |> list.map(dict.to_list)
  |> list.map(fn(l) {
    list.sort(l, by: fn(p1, p2) {
      int.compare(pair.second(p1), pair.second(p2))
    })
  })
  |> list.map(fn(x) {
    case list.last(x) {
      Ok(i) -> i
      Error(_) -> panic
    }
  })
  |> list.map(pair.first)
  |> string.concat
}

fn p2() {
  utils.lines(filename: "inputs/day06.p1")
  |> list.map(string.split(_, on: ""))
  |> list.transpose
  |> list.map(utils.frequencies)
  |> list.map(dict.to_list)
  |> list.map(list.sort(_, by: fn(p1, p2) {
    int.compare(pair.second(p1), pair.second(p2))
  }))
  |> list.map(fn(x) {
    case list.first(x) {
      Ok(i) -> i
      Error(_) -> panic
    }
  })
  |> list.map(pair.first)
  |> string.concat
}

pub fn main() {
  debug(p1())
  debug(p2())
}
