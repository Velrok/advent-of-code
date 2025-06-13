import gleam/int
import gleam/list
import gleam/string
import utils

pub type Register {
  A
  B
}

pub type Instruction {
  Hlf(Register)
  // hlf r sets register r to half its current value, then continues with the next instruction.
  Tpl(Register)
  // tpl r sets register r to triple its current value, then continues with the next instruction.
  Inc(Register)
  // inc r increments register r, adding 1 to it, then continues with the next instruction.
  Jmp(Int)
  // jmp offset is a jump; it continues with the instruction offset away relative to itself.
  Jie(Register, Int)
  // jie r, offset is like jmp, but only jumps if register r is even ("jump if even").
  Jio(Register, Int)
  // jio r, offset is like jmp, but only jumps if register r is 1 ("jump if one", not odd).
}

fn parse_instructions(filename: String) -> List(Instruction) {
  let lines = utils.lines(filename)
  lines
  |> list.map(fn(line) {
    let assert Ok(#(instr, args)) = string.split_once(line, on: " ")
    let args = case string.split_once(args, on: ", ") {
      Error(_) -> [args]
      Ok(#(left, right)) -> [left, right]
    }
    case list.append([instr], args) {
      [] -> panic
      ["inc", r] -> Inc(register_from_str(r))
      ["hlf", r] -> Hlf(register_from_str(r))
      ["jio", r, offset_str] -> {
        let assert Ok(offset) = int.parse(offset_str)
        Jio(register_from_str(r), offset)
      }
      ["jie", r, offset_str] -> {
        let assert Ok(offset) = int.parse(offset_str)
        Jie(register_from_str(r), offset)
      }
      ["tpl", r] -> Tpl(register_from_str(r))
      ["jmp", offset_str] -> {
        let assert Ok(offset) = int.parse(offset_str)
        Jmp(offset)
      }
      [_, ..] -> {
        let msg = "unknown instruction " <> instr
        panic as msg
      }
    }
  })
}

fn register_from_str(arg: String) -> Register {
  case arg {
    "a" -> A
    "b" -> B
    _ -> {
      let msg = "Unknown regiser" <> arg
      panic as msg
    }
  }
}

type State =
  #(Int, Int)

pub fn part1(instructions: List(Instruction)) -> State {
  // part 2 is just starting with #(1, 0) instead
  let state = #(0, 0)
  run(state, instructions, 0)
}

fn run(
  state: State,
  instructions: List(Instruction),
  program_pointer: Int,
) -> State {
  let instruction =
    instructions
    |> list.drop(program_pointer)
    |> list.first()

  case instruction {
    Error(_) -> state
    Ok(instruction) -> {
      let #(a, b) = state
      echo #(state, instruction, program_pointer)
      case instruction {
        Inc(r) ->
          case r {
            A -> run(#(a + 1, b), instructions, program_pointer + 1)
            B -> run(#(a, b + 1), instructions, program_pointer + 1)
          }

        Jio(r, offset) -> {
          let check = case r {
            A -> a
            B -> b
          }
          case check == 1 {
            True -> run(state, instructions, program_pointer + offset)
            False -> run(state, instructions, program_pointer + 1)
          }
        }

        Jie(r, offset) -> {
          let check = case r {
            A -> a
            B -> b
          }
          case int.is_even(check) {
            True -> run(state, instructions, program_pointer + offset)
            False -> run(state, instructions, program_pointer + 1)
          }
        }

        Jmp(offset) -> {
          run(state, instructions, program_pointer + offset)
        }

        Tpl(r) ->
          case r {
            A -> run(#(a * 3, b), instructions, program_pointer + 1)
            B -> run(#(a, b * 3), instructions, program_pointer + 1)
          }

        Hlf(r) ->
          case r {
            A -> run(#(a / 2, b), instructions, program_pointer + 1)
            B -> run(#(a, b / 2), instructions, program_pointer + 1)
          }
      }
    }
  }
}

pub fn main() {
  // let instructions: List(Instruction) =
  //  parse_instructions("inputs/day23.exampmle")
  let instructions: List(Instruction) = parse_instructions("inputs/day23")
  echo instructions
  echo part1(instructions)
}
