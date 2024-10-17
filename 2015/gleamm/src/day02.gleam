import gleam/io.{debug}
import gleam/list.{filter, map, reduce}
import gleam/string.{split}
import gleam/int
import gleam/result
import utils

// gleam run -m day02
pub fn main() {
  let result =
    utils.lines(filename: "inputs/02.p1")
    |> filter(fn(line) { line != "" })
    |> map(fn(line) {
      // debug(line)
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

  debug(result)
}
