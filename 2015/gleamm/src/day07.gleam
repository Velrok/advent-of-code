import gleam/int
import gleam/list
import gleam/option.{type Option}
import gleam/regexp
import gleam/string
import utils

fn part1(circuts) {
  circuts
  |> list.map(fn(x) { echo x })
}

// gleam run -m day07
pub fn main() {
  let circuts = parse("./inputs/day07.example")
  part1(circuts)
}

pub type Operation {
  And(left: Option(Int), right: Option(Int))
  Or(left: Option(Int), right: Option(Int))
  Not(left: Option(Int))
  Lshift(left: Option(Int), right: Int)
  Rshift(left: Option(Int), right: Int)
  Const(left: Int)
}

pub type Circut {
  Circut(inputs: List(String), output: String, operation: Operation)
}

fn parse(filename: String) {
  let lines = utils.lines(filename)
  lines |> list.map(parse_circut)
}

fn parse_circut(line: String) -> Circut {
  let assert Ok(#(instruction, output)) = string.split_once(line, on: " -> ")

  let assert Ok(inputs_re) = regexp.from_string("([a-z]+)")
  let inputs =
    regexp.scan(inputs_re, instruction)
    |> list.flat_map(fn(m) { m.submatches })
    |> option.values()

  let assert Ok(operation_re) = regexp.from_string("(AND|OR|LSHIFT|RSHIFT|NOT)")
  let operation = case regexp.scan(operation_re, instruction) {
    [] -> {
      case int.parse(instruction) {
        Error(_) -> panic
        Ok(n) -> Const(n)
      }
    }
    [m] -> {
      let assert [option.Some(op)] = m.submatches
      case op {
        "AND" -> {
          let assert Ok(#(left, right)) = string.split_once(instruction, "AND")
          And(
            left: option.from_result(int.parse(left)),
            right: option.from_result(int.parse(right)),
          )
        }
        "OR" -> {
          let assert Ok(#(left, right)) = string.split_once(instruction, "OR")
          Or(
            left: option.from_result(int.parse(left)),
            right: option.from_result(int.parse(right)),
          )
        }
        "LSHIFT" -> {
          let assert Ok(#(left, right)) =
            string.split_once(instruction, "LSHIFT")
          Lshift(
            left: option.from_result(int.parse(left)),
            right: case right |> string.trim |> int.parse {
              Ok(x) -> x
              _ -> panic
            },
          )
        }
        "RSHIFT" -> {
          let assert Ok(#(left, right)) =
            string.split_once(instruction, "RSHIFT")
          Rshift(
            left: option.from_result(int.parse(left)),
            right: case right |> string.trim |> int.parse {
              Ok(x) -> x
              _ -> panic
            },
          )
        }
        "NOT" -> {
          let assert Ok(#(_left, right)) = string.split_once(instruction, "NOT")
          Not(left: option.from_result(int.parse(right)))
        }
        _ -> panic
      }
    }
    _ -> panic
  }

  Circut(output: output, inputs: inputs, operation: operation)
}
