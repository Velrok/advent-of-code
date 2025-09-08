import gleam/int
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(content) = simplifile.read(from: "inputs/day08")
  let lines = content |> string.trim |> string.split(on: "\n")
  let instructions = lines |> list.map(parse_instruction)
  list.fold(instructions, set.new(), apply_instruction)
  echo instructions
}

fn apply_instruction(lights: Set(Light), instruction: Instruction) -> Set(Light) {
  case instruction {
    Rect(w:, h:) -> {
      list.map2(list.range(0, h), list.range(0, w), fn(y, x) { Light(x:, y:) })
      |> set.from_list
      |> set.union(lights)
    }
    RotateColumn(x:, by:) -> todo
    RotateRow(y:, by:) -> todo
  }
}

pub type Light {
  Light(x: Int, y: Int)
}

pub type Instruction {
  Rect(w: Int, h: Int)
  RotateColumn(x: Int, by: Int)
  RotateRow(y: Int, by: Int)
}

fn parse_instruction(line: String) -> Instruction {
  let assert [command, ..subcommands] = string.split(line, on: " ")
  case command {
    "rect" -> {
      let assert [w, h] =
        subcommands
        |> list.first
        |> result.lazy_unwrap(fn() { panic })
        |> string.split(on: "x")
        |> list.map(int.parse)
        |> result.values()
      Rect(w:, h:)
    }
    "rotate" -> {
      let assert [subcommand, ..more] = subcommands
      let assert [index_expression, _by, by_str] = more
      let assert [_, index_str] = string.split(index_expression, on: "=")
      let assert Ok(index) = int.parse(index_str)
      let assert Ok(by) = int.parse(by_str)

      case subcommand {
        "column" -> {
          RotateColumn(index, by)
        }
        "row" -> {
          RotateRow(index, by)
        }
        _ as unknown -> {
          echo unknown
          panic
        }
      }
    }
    _ as unknown -> {
      echo unknown
      panic
    }
  }
}
