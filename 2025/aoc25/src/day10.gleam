import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/regexp
import gleam/result
import gleam/string
import iv.{type Array}
import simplifile
import utils.{panic_on_error}

pub type Button {
  Button(indecies: List(Int))
}

pub type Machine {
  Machine(lights: Array(Bool), buttons: List(Button))
}

pub fn main() {
  let input_file = "inputs/day10.example"
  let _input =
    simplifile.read(input_file)
    |> panic_on_error("Can't load " <> input_file)
    |> string.trim_end()
    |> string.split("\n")
    |> list.map(machine_from_string)
    |> echo
  // ☑️TODO: update Machine type to have desired state and current state
  // for all possible button seqences of length 1
  // does it produce desired state -> done
  // otherwise for all possible button seqences of length +1
}

fn machine_from_string(line) -> Machine {
  // [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  let assert Ok(#(lights_diagram, rest)) = string.split_once(line, " ")
  let lights = parse_lights(lights_diagram)
  let buttons = parse_buttons(rest)

  Machine(lights: lights, buttons: buttons)
}

fn parse_buttons(line: String) -> List(Button) {
  // line = (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  let re =
    regexp.from_string("\\(([\\d,]*)\\)") |> panic_on_error("invalid regexp")

  regexp.scan(re, line)
  |> list.map(fn(match) {
    let assert [Some(indecies_str)] = match.submatches
    indecies_str
  })
  |> list.map(parse_button)
}

fn parse_button(str: String) -> Button {
  Button(
    indecies: str
    |> string.split(",")
    |> list.map(int.parse)
    |> result.values(),
  )
}

fn parse_lights(lights_diagram) -> Array(Bool) {
  lights_diagram
  |> string.to_graphemes()
  |> list.map(fn(c) {
    case c {
      "." -> Some(False)
      "#" -> Some(True)
      _ -> None
    }
  })
  |> option.values()
  |> iv.from_list()
}
