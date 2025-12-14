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
  Machine(
    lights_diagram: Array(Bool),
    lights_state: Array(Bool),
    buttons: List(Button),
  )
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
  let tokens = line |> string.split(" ")

  let machine = {
    use machine, token <- list.fold(
      tokens,
      Machine(lights_diagram: iv.new(), lights_state: iv.new(), buttons: []),
    )

    case string.first(token) {
      Ok("[") -> Machine(..machine, lights_diagram: parse_lights(token))
      Ok("(") ->
        Machine(..machine, buttons: [parse_button(token), ..machine.buttons])
      Ok("{") -> machine
      // ignore for Part1
      _ -> {
        let msg = "cant parse " <> token
        panic as msg
      }
    }
  }

  let count = iv.length(machine.lights_diagram)
  let lights_state = list.repeat(False, count) |> iv.from_list()

  Machine(..machine, buttons: list.reverse(machine.buttons), lights_state:)
}

fn parse_button(str: String) -> Button {
  Button(
    indecies: str
    // take out wrapping ()
    |> string.slice(at_index: 1, length: string.length(str) - 2)
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
