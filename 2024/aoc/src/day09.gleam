import gleam/int
import gleam/io.{debug}
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let from = "inputs/day09.example"
  let assert Ok(puzzle_input) = simplifile.read(from: from)
  part01(string.split(puzzle_input, ""))
}

type DiskMap =
  List(String)

fn part01(disk_map: DiskMap) {
  expand(disk_map)
  //  |> compact
  //  |> checksum
}

fn expand(disk_map: DiskMap) {
  list.index_fold(disk_map, [], fn(expanded, x, index) {
    case int.is_odd(index) {
      True -> todo as "handle empty space"
      False -> todo as "insert index x times"
    }
  })
}
