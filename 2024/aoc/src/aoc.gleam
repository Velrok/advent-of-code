import gleam/io
import gleam/list
import utils

pub fn main() {
  utils.grid_positions(list.range(0, 3), list.range(5, 7))
  |> io.debug()
}
