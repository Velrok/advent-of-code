import gleam/io.{debug}
import gleam/list.{first, fold}
import gleam/string.{split}
import gleam/set
import utils

type Position {
  Position(x: Int, y: Int)
}

fn p1() {
  let assert Ok(line) = first(utils.lines(filename: "./inputs/03.p1"))

  let starting_location = Position(x: 0, y: 0)
  let #(visited_locations, _) =
    split(line, on: "")
    |> fold(
      from: #(set.from_list([starting_location]), starting_location),
      with: fn(state, instruction) {
        let #(visited_locations, current_pos) = state
        let new_pos = case instruction {
          "^" -> Position(x: current_pos.x, y: current_pos.y + 1)
          ">" -> Position(x: current_pos.x + 1, y: current_pos.y)
          "v" -> Position(x: current_pos.x, y: current_pos.y - 1)
          "<" -> Position(x: current_pos.x - 1, y: current_pos.y)
          _ -> panic
        }
        #(set.insert(visited_locations, new_pos), new_pos)
      },
    )

  set.size(visited_locations)
}

type Mover {
  Santa
  Robot
}

type SantaTracker {
  SantaTracker(
    locations: set.Set(Position),
    santa: Position,
    robot: Position,
    mover: Mover,
  )
}

fn add(p1: Position, p2: Position) {
  Position(x: p1.x + p2.x, y: p1.y + p2.y)
}

fn p2() {
  let assert Ok(line) =
    utils.lines(filename: "./inputs/03.p1")
    |> first

  let starting_location = Position(x: 0, y: 0)
  let state =
    SantaTracker(
      locations: set.new()
        |> set.insert(starting_location),
      mover: Santa,
      santa: starting_location,
      robot: starting_location,
    )

  let end_state =
    split(line, on: "")
    |> fold(from: state, with: fn(state, instruction) {
      let diff = case instruction {
        "^" -> Position(x: 0, y: 1)
        ">" -> Position(x: 1, y: 0)
        "v" -> Position(x: 0, y: -1)
        "<" -> Position(x: -1, y: 0)
        _ -> panic
      }

      case state.mover {
        Santa -> {
          let santa_next_pos = add(state.santa, diff)
          SantaTracker(
            locations: set.insert(state.locations, santa_next_pos),
            mover: Robot,
            santa: santa_next_pos,
            robot: state.robot,
          )
        }

        Robot -> {
          let robot_next_pos = add(state.robot, diff)
          SantaTracker(
            locations: set.insert(state.locations, robot_next_pos),
            mover: Santa,
            santa: state.santa,
            robot: robot_next_pos,
          )
        }
      }
    })

  set.size(end_state.locations)
}

// gleam run -m day02
pub fn main() {
  debug(p1())
  debug(p2())
}
