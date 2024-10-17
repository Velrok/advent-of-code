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
    |> filter(fn(s) { s != "" })
    |> map(fn(s) {
      // debug(s)
      let assert [l, w, h] =
        split(s, on: "x")
        |> map(int.parse)
        |> result.values
      let sq_ft = 2 * l * w + 2 * w * h + 2 * h * l
      let assert Ok(slack) =
        [l * w, w * h, h * l]
        |> reduce(int.min)

      sq_ft + slack
    })
    |> reduce(fn(x, y) { x + y })

  debug(result)
}
