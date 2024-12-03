import gleam/io.{debug}
import gleam/regexp
import gleam/string
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import utils

const instruction_re = "(do\\(\\)|don't\\(\\)|mul\\((\\d{1,3}),(\\d{1,3})\\))"

type Instruction {
  Mult(x: Int, y: Int)
  Do
  Dont
}

type InstructionResult {
  Result(x: Int)
  Active
  InActive
}

// let assert Ok(re) = regexp.from_string("[0-9]")

fn interpret_mult(m: regexp.Match) {
  case m.submatches {
    [_, Some(xs), Some(ys)] -> {
      let assert Ok(x) = int.parse(xs)
      let assert Ok(y) = int.parse(ys)
      Mult(x, y)
    }
    _ -> panic
  }
}

fn interpret_match(m: regexp.Match) {
  case m.content {
    "don't()" -> Dont
    "do()" -> Do
    _ -> interpret_mult(m)
  }
}

fn extract_instructions(str) {
  let assert Ok(re) = regexp.from_string(instruction_re)
  let matches = regexp.scan(re, str)
  matches
  |> list.map(interpret_match)
}

fn apply(instruction) {
  case instruction {
    Mult(x, y) -> Result(x * y)
    Do -> Active
    Dont -> InActive
  }
}

pub fn main() {
  // let input =
  //   "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

  let input =
    utils.lines("inputs/day01.input")
    |> string.concat

  let instructions = extract_instructions(input)

  // // part01
  // instructions
  // |> list.map(apply(_))
  // |> int.sum
  // |> debug

  // part 2
  instructions
  |> list.fold(#(True, 0), fn(agg, instrunction) {
    debug(agg)
    let #(active, sum) = agg
    case apply(instrunction) {
      Result(x) ->
        case active {
          True -> #(active, sum + x)
          False -> #(active, sum)
        }
      Active -> #(True, sum)
      InActive -> #(False, sum)
    }
  })
  |> debug
}
