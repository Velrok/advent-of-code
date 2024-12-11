import gleam/string
import gleam/int
import gleam/set
import gleam/dict
import gleam/list
import gleam/result
import gleam/option.{type Option, None, Some}
import gleam/io.{debug}
import utils.{type Point, Grid}
import simplifile

fn valid_step(
  next_elevaion: Int,
  current_elevation: Int,
  next_pos: Point,
  previous_pos: Option(Point),
) -> Bool {
  case previous_pos {
    Some(previous_pos) ->
      next_elevaion == current_elevation + 1 && next_pos != previous_pos
    None -> next_elevaion == current_elevation + 1
  }
}

fn explore(
  grid: utils.Grid(Int),
  current_pos: Point,
  current_path: Path,
  previous_pos: Option(Point),
) {
  case dict.get(grid.data, current_pos) {
    Error(_) -> []
    Ok(elevation) ->
      case elevation {
        // reached an end!
        9 -> [current_path]
        current_elevation -> {
          [utils.north, utils.south, utils.east, utils.west]
          |> list.map(fn(step_fn) {
            let next_pos = step_fn(current_pos)
            case dict.get(grid.data, next_pos) {
              Error(_) -> []
              Ok(next_elevaion) -> {
                case
                  valid_step(
                    next_elevaion,
                    current_elevation,
                    next_pos,
                    previous_pos,
                  )
                {
                  False -> []
                  True -> find_trails(grid, [next_pos, ..current_path])
                }
              }
            }
          })
          |> list.flatten()
        }
      }
  }
}

fn find_trails(grid: utils.Grid(Int), current_path: Path) -> List(Path) {
  // gleam list are linked lists so we prepend all elements meaning the last one is always at the front.
  case current_path {
    [current_pos] -> explore(grid, current_pos, current_path, None)

    [current_pos, previous_pos, ..] ->
      explore(grid, current_pos, current_path, Some(previous_pos))

    _ -> panic
  }
}

type Path =
  List(Point)

fn part01(grid, trailheads) {
  trailheads
  // |> list.drop(2)
  // |> list.take(1)
  // |> list.map(fn(trailhead) { #(trailhead, find_trails(grid, trailhead, "")) })
  |> list.map(fn(trailhead) {
    find_trails(grid, [trailhead])
    |> list.map(list.first)
    |> set.from_list()
    |> set.size()
  })
  |> list.reduce(int.add)
}

fn part02(grid, trailheads) {
  trailheads
  // |> list.drop(2)
  // |> list.take(1)
  // |> list.map(fn(trailhead) { #(trailhead, find_trails(grid, trailhead, "")) })
  |> list.map(fn(trailhead) {
    find_trails(grid, [trailhead])
    |> set.from_list()
    |> set.size()
  })
  |> list.reduce(int.add)
}

pub fn main() {
  let example =
    "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"

  let assert Ok(input) = simplifile.read(from: "inputs/day10.input")

  let grid =
    utils.parse_grid(input, fn(s) {
      let assert Ok(i) =
        s
        |> int.parse()
      i
    })

  let trailheads =
    grid.data
    |> dict.filter(fn(_pos, elevation) { elevation == 0 })
    |> dict.keys

  debug(trailheads)
  // part01(grid, trailheads)
  part02(grid, trailheads)
  |> debug
}
