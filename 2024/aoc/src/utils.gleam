import simplifile
import gleam/int
import gleam/io
import gleam/dict
import gleam/result
import gleam/string
import gleam/list

pub fn lines(filename from: String) {
  let assert Ok(puzzle_input) = simplifile.read(from: from)
  string.split(puzzle_input, on: "\n")
  |> list.filter(fn(line) { line != "" })
}

pub type Point {
  Point(x: Int, y: Int)
}

pub fn north(p: Point) {
  Point(p.x, p.y - 1)
}

pub fn south(p: Point) {
  Point(p.x, p.y + 1)
}

pub fn east(p: Point) {
  Point(p.x + 1, p.y)
}

pub fn west(p: Point) {
  Point(p.x - 1, p.y)
}

pub type Grid(cell_type) {
  Grid(data: dict.Dict(Point, cell_type), width: Int, height: Int)
}

pub fn parse_grid(
  from example: String,
  with cell_parser: fn(String) -> a,
) -> Grid(a) {
  let lines = string.split(example, "\n")
  let grid = list.map(lines, string.split(_, ""))

  let height = list.length(lines)
  let width =
    grid
    |> list.first()
    |> result.unwrap([])
    |> list.length()

  let init = dict.new()
  let data =
    list.index_fold(grid, init, fn(outer_index, line, y) {
      list.index_fold(line, outer_index, fn(inner_index, elem, x) {
        dict.insert(inner_index, Point(x: x, y: y), cell_parser(elem))
      })
    })

  Grid(data: data, width: width, height: height)
}

pub fn parse_int_or_panic(s: String) -> Int {
  case
    s
    |> int.parse()
  {
    Error(_) -> {
      io.debug("Cant parse " <> s <> " as int!")
      panic
    }
    Ok(i) -> i
  }
}

pub fn simulate(n: Int, agg, sim_f) {
  case n {
    0 -> agg
    1 -> sim_f(agg)
    _ -> simulate(n - 1, sim_f(agg), sim_f)
  }
}

pub fn grid_positions(
  y_range: List(Int),
  x_range: List(Int),
) -> List(#(Int, Int)) {
  use y <- list.flat_map(y_range)
  use x <- list.map(x_range)
  #(x, y)
}
