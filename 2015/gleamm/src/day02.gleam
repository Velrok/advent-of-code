import gleam/io.{debug}
import gleam/list.{filter, map, reduce, take}
import gleam/string.{split}
import gleam/int
import gleam/result
import utils

fn p1() {
  utils.lines(filename: "inputs/02.p1")
  |> map(fn(line) {
    let assert [l, w, h] =
      split(line, on: "x")
      |> map(int.parse)
      |> result.values

    let sq_ft = 2 * l * w + 2 * w * h + 2 * h * l

    let assert Ok(slack) =
      [l * w, w * h, h * l]
      |> reduce(int.min)

    sq_ft + slack
  })
  |> int.sum
}

fn p2() {
  utils.lines(filename: "inputs/02.p1")
  |> filter(fn(line) { line != "" })
  |> map(fn(line) {
    let assert [l, w, h] =
      split(line, on: "x")
      |> map(int.parse)
      |> result.values

    let ribbon_ft: Int =
      [l, w, h]
      |> list.sort(by: int.compare)
      |> take(2)
      |> int.sum
      |> int.multiply(2)

    let assert Ok(bow_ft) =
      [l, w, h]
      |> reduce(int.multiply)

    ribbon_ft + bow_ft
  })
  |> int.sum
}

// gleam run -m day02
pub fn main() {
  debug(p1())
  debug(p2())
}
