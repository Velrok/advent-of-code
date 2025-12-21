import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import gleam/yielder
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
  let machines =
    simplifile.read(input_file)
    |> panic_on_error("Can't load " <> input_file)
    |> string.trim_end()
    |> string.split("\n")
    |> list.map(parse_machine)

  let min_button_presses =
    machines
    |> list.map(find_minimal_button_presses)
    |> echo
}

fn find_minimal_button_presses(machine: Machine) -> Int {
  let button_combinations = repeating_permutations(machine.buttons)
  button_combinations
  |> yielder.take(10)
  |> yielder.chunk(produces_light_diagram_match(machine, _))
  |> yielder.take(2)
  // [invalid_combinations, valid_combinations]
  |> yielder.last()
  // valid_combinations
  |> panic_on_error("could not find valid combinations")
  |> list.first()
  // first valid_combination
  |> panic_on_error("valid combinations is empty")
  |> list.length()
  // numbers ob buttons in the list that produces a stable state
}

fn produces_light_diagram_match(m: Machine, list: List(Button)) -> Bool {
  let m2 = press_buttons(m, list)
  m2.lights_state == m2.lights_diagram
}

fn press_buttons(m: Machine, buttons_seq: List(Button)) -> Machine {
  use m, btn <- list.fold(buttons_seq, m)
  let lights_state =
    m.lights_state
    |> iv.index_map(fn(is_on, index) {
      case list.contains(btn.indecies, index) {
        True -> !is_on
        False -> is_on
      }
    })
  Machine(..m, lights_state: lights_state)
  // Machine(..m, lights_state:)
}

fn parse_machine(line) -> Machine {
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

fn repeating_permutations(l: List(a)) {
  let numbers = yielder.iterate(1, int.add(1, _))
  yielder.flat_map(numbers, fn(i) {
    list.repeat(l, i)
    |> list.flatten()
    |> list.permutations()
    |> list.unique()
    |> yielder.from_list()
  })
}
