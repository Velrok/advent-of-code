import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  // "inputs/day01"
  // |> simplifile.read()
  // |> fn(r) {
  //   case r {
  //     Error(_) -> panic as "Cant read inputs/day01"
  //     Ok(x) -> x
  //   }
  // }
  "R8, R4, R4, R8"
  |> parse_input()
  |> part02
  |> io.println()
}

fn next_pos(pos: Position, instr: Instruction) -> Position {
  // echo #(pos, instr)
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
}

fn part01(instructions: List(Instruction)) -> String {
  let start = Position(North, 0, 0)
  let final_pos =
    list.fold(instructions, start, fn(pos, instr) { next_pos(pos, instr) })

  int.to_string(
    int.absolute_value(final_pos.y) + int.absolute_value(final_pos.x),
  )
}

type Location =
  #(Int, Int)

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
          echo #(pos, instr)

          let dist = case instr {
            L(x) -> x
            R(x) -> x
          }

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

          case new_direction {
            East -> #(
              Position(new_direction, x: pos.x + dist, y: pos.y),
              list.append(
                hist,
                list.range(pos.x, pos.x + dist)
                  |> list.map(fn(x) { #(x, pos.y) }),
              ),
            )
            West -> #(
              Position(new_direction, x: pos.x - dist, y: pos.y),
              list.append(
                hist,
                list.range(pos.x, pos.x - dist)
                  |> list.map(fn(x) { #(x, pos.y) }),
              ),
            )
            North -> #(
              Position(new_direction, x: pos.x, y: pos.y + dist),
              list.append(
                hist,
                list.range(pos.y, pos.y + dist)
                  |> list.map(fn(y) { #(pos.x, y) }),
              ),
            )
            South -> #(
              Position(new_direction, x: pos.x, y: pos.y - dist),
              list.append(
                hist,
                list.range(pos.y, pos.y - dist)
                  |> list.map(fn(y) { #(pos.x, y) }),
              ),
            )
          }
        }
      }
    })
  // let instr_counter = 0
  // let location_history: List(Location) = []
  // let final_pos = travel(instructions, instr_counter, location_history, start)

  int.to_string(
    int.absolute_value(final_pos.y) + int.absolute_value(final_pos.x),
  )
}

fn travel(
  instructions: List(Instruction),
  instr_counter: Int,
  location_history: List(#(Int, Int)),
  pos: Position,
) -> Position {
  let index = instr_counter % list.length(instructions)
  let assert Ok(instr) = instructions |> list.drop(index) |> list.first()
  echo #(instr_counter, pos, instr, location_history)
  case list.contains(location_history, #(pos.x, pos.y)) {
    True -> pos
    False -> {
      travel(
        instructions,
        instr_counter + 1,
        [#(pos.x, pos.y), ..location_history],
        next_pos(pos, instr),
      )
    }
  }
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
