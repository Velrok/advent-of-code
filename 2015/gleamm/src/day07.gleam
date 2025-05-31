import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/regexp
import gleam/string
import utils

fn part1(circuts: List(Circut), state: dict.Dict(String, Int)) {
  let #(new_state, remaining_instructions) = apply_all(circuts, state)
  case remaining_instructions {
    [] -> dict.get(new_state, "a")
    [_, ..] -> part1(remaining_instructions, new_state)
  }
}

fn apply_all(
  circuts: List(Circut),
  state: dict.Dict(String, Int),
) -> #(dict.Dict(String, Int), List(Circut)) {
  list.fold(circuts, #(state, []), fn(agg, circut) {
    let #(state, remaining_circuts) = agg
    let result = apply(circut, state)
    case result {
      Error(_) -> #(state, list.append(remaining_circuts, [circut]))
      Ok(val) -> #(dict.insert(state, circut.output, val), remaining_circuts)
    }
  })
}

fn apply(circut: Circut, state: dict.Dict(String, Int)) -> Result(Int, Nil) {
  let #(input_l, input_r) = case list.map(circut.inputs, dict.get(state, _)) {
    [input_l, input_r] -> #(input_l, input_r)
    [] -> #(Error(Nil), Error(Nil))
    [input_l] -> #(input_l, Error(Nil))
    [_, _, _, ..] -> panic
  }
  let lookup_and_apply = fn(l, r, input_l, input_r, int_op) {
    case l, r {
      Some(l), Some(r) -> Ok(int_op(l, r))
      None, Some(r) ->
        case input_l {
          Error(_) -> Error(Nil)
          Ok(in_l) -> Ok(int_op(in_l, r))
        }
      Some(l), None ->
        case input_l {
          Error(_) -> Error(Nil)
          Ok(in_l) -> Ok(int_op(l, in_l))
        }
      None, None -> {
        case input_l, input_r {
          Ok(in_l), Ok(in_r) -> Ok(int_op(in_l, in_r))
          _, _ -> Error(Nil)
        }
      }
    }
  }
  case circut.operation {
    Const(c) -> Ok(c)
    And(l, r) -> lookup_and_apply(l, r, input_l, input_r, int.bitwise_and)
    Or(l, r) -> lookup_and_apply(l, r, input_l, input_r, int.bitwise_or)
    Lshift(l, r) ->
      lookup_and_apply(l, Some(r), input_l, input_r, int.bitwise_shift_left)
    Rshift(l, r) ->
      lookup_and_apply(l, Some(r), input_l, input_r, int.bitwise_shift_right)
    Not(l) ->
      case l {
        None ->
          case input_l {
            Error(_) -> Error(Nil)
            Ok(l) -> Ok(int.bitwise_not(l))
          }
        Some(l) -> Ok(int.bitwise_not(l))
      }
  }
}

// gleam run -m day07
pub fn main() {
  let circuts = parse("./inputs/day07.example")
  let state: dict.Dict(String, Int) = dict.new()
  echo part1(circuts, state)
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
