import gleam/dict
import gleam/io.{debug}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/pair
import gleam/result
import gleam/set
import gleam/string
import simplifile

type Point {
  Point(x: Int, y: Int)
}

type Grid {
  Grid(data: dict.Dict(Point, String), width: Int, height: Int)
}

type Direction {
  North
  East
  South
  West
}

type Guard {
  Guard(pos: Point, direction: Direction)
}

fn parse_grid(from example: String) -> Grid {
  let lines = string.split(example, "\n")
  let grid = list.map(lines, string.split(_, ""))

  let height = list.length(lines)
  let width = grid |> list.first() |> result.unwrap([]) |> list.length()

  let init = dict.new()
  let data =
    list.index_fold(grid, init, fn(outer_index, line, y) {
      list.index_fold(line, outer_index, fn(inner_index, elem, x) {
        dict.insert(inner_index, Point(x: x, y: y), elem)
      })
    })

  Grid(data: data, width: width, height: height)
}

fn turn(d: Direction) -> Direction {
  case d {
    North -> East
    East -> South
    South -> West
    West -> North
  }
}

fn move(grid: Grid, guard: Guard) -> Option(Guard) {
  let current_pos = guard.pos
  let next_pos = case guard.direction {
    North -> Point(..current_pos, y: current_pos.y - 1)
    South -> Point(..current_pos, y: current_pos.y + 1)
    West -> Point(..current_pos, x: current_pos.x - 1)
    East -> Point(..current_pos, x: current_pos.x + 1)
  }

  case dict.get(grid.data, next_pos) {
    Error(_) -> None
    Ok(next_pos_content) -> {
      case next_pos_content {
        "#" -> Some(Guard(pos: current_pos, direction: turn(guard.direction)))
        _ -> Some(Guard(pos: next_pos, direction: guard.direction))
      }
    }
  }
}

fn track(path: List(Point), grid: Grid, guard: Guard) -> List(Point) {
  debug(guard)
  let next_guard = move(grid, guard)
  case next_guard {
    None -> path
    Some(g) -> {
      track([g.pos, ..path], grid, g)
    }
  }
}

fn part01(input: Grid) {
  let assert Ok(start_pair) =
    input.data
    |> dict.to_list()
    |> list.find(fn(kv) {
      let #(_pos, val) = kv
      val == "^"
    })

  let start_pos = start_pair |> pair.first()

  let guard = Guard(pos: start_pos, direction: North)
  let path = track([guard.pos], input, guard)
  debug("steps taken")
  path |> set.from_list() |> set.size() |> debug
}

pub fn main() {
  let example =
    "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."

  let assert Ok(input) = simplifile.read(from: "inputs/day06.input")
  let grid = parse_grid(from: input)
  part01(grid) |> debug
  True
}
