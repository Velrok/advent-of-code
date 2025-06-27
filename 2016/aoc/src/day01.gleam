import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  "inputs/day01"
  |> simplifile.read()
  |> fn(r) {
    case r {
      Error(_) -> panic as "Cant read inputs/day01"
      Ok(x) -> x
    }
  }
  |> parse_input()
  |> part02
  |> io.println()
}

fn part01(instructions: List(Instruction)) -> String {
  let start = Position(North, 0, 0)
  let final_pos =
    list.fold(instructions, start, fn(pos, instr) {
      echo #(pos, instr)
      let new_direction = case instr {
        L(_) ->
          case pos.direction {
            North -> West
            West -> South
            South -> East
            East -> North
          }
        R(_) ->
          case pos.direction {
            North -> East
            East -> South
            South -> West
            West -> North
          }
      }
      let dist = case instr {
        L(x) -> x
        R(x) -> x
      }
      case new_direction {
        East -> Position(new_direction, x: pos.x + dist, y: pos.y)
        West -> Position(new_direction, x: pos.x - dist, y: pos.y)
        North -> Position(new_direction, x: pos.x, y: pos.y + dist)
        South -> Position(new_direction, x: pos.x, y: pos.y - dist)
      }
    })

  int.to_string(
    int.absolute_value(final_pos.y) + int.absolute_value(final_pos.x),
  )
}

fn part02(instructions: List(Instruction)) -> String {
  let start = Position(North, 0, 0)
  let location_history: List(#(Int, Int)) = []
  let #(final_pos, _) =
    list.fold(instructions, #(start, location_history), fn(state, instr) {
      let #(pos, hist) = state
      echo hist
      // buggy
      case list.contains(hist, #(pos.x, pos.y)) {
        True -> #(pos, hist)
        False -> {
          let new_hist = [#(pos.x, pos.y), ..hist]
          echo #(pos, instr)
          let new_direction = case instr {
            L(_) ->
              case pos.direction {
                North -> West
                West -> South
                South -> East
                East -> North
              }
            R(_) ->
              case pos.direction {
                North -> East
                East -> South
                South -> West
                West -> North
              }
          }
          let dist = case instr {
            L(x) -> x
            R(x) -> x
          }
          case new_direction {
            East -> #(
              Position(new_direction, x: pos.x + dist, y: pos.y),
              new_hist,
            )
            West -> #(
              Position(new_direction, x: pos.x - dist, y: pos.y),
              new_hist,
            )
            North -> #(
              Position(new_direction, x: pos.x, y: pos.y + dist),
              new_hist,
            )
            South -> #(
              Position(new_direction, x: pos.x, y: pos.y - dist),
              new_hist,
            )
          }
        }
      }
    })

  int.to_string(
    int.absolute_value(final_pos.y) + int.absolute_value(final_pos.x),
  )
}

pub type Position {
  Position(direction: Direction, x: Int, y: Int)
}

pub type Direction {
  North
  East
  South
  West
}

pub type Instruction {
  L(Int)
  R(Int)
}

fn parse_input(str: String) -> List(Instruction) {
  let items = str |> string.trim() |> string.split(on: ", ")

  use item <- list.map(items)

  case string.to_graphemes(item) {
    [direction_str, ..numbers_str] -> {
      let distance = case numbers_str |> string.join("") |> int.parse() {
        Error(_) -> {
          let msg = "cant parse `" <> string.join(numbers_str, "") <> "`"
          panic as msg
        }
        Ok(n) -> n
      }

      case direction_str {
        "L" -> L(distance)
        "R" -> R(distance)
        // 🤦
        _ -> {
          let msg = "unknown direction " <> direction_str
          panic as msg
        }
      }
    }

    _ -> panic as "unknown Instruction format"
  }
}
