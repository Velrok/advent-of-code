import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/string
import simplifile
import vector2d

// type Board =
//  Dict(Vec, String)

pub fn main() {
  // let assert Ok(input) = simplifile.read(from: "inputs/day15.input")
  let assert Ok(input) = simplifile.read(from: "inputs/day15.example")
  let assert [field_lines, instructions] =
    input
    |> string.split("\n")
    |> list.chunk(fn(l) { l == "" })
    |> list.filter(fn(l) { l != [""] })
    |> io.debug

  let board = parse_board(field_lines)
}

fn parse_board(field_lines) {
  todo
}
