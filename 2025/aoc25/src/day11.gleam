import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(content) = simplifile.read("inputs/day11")
  let paths =
    content
    |> string.trim_end()
    |> parse()

  echo follow(["you"], 0, paths)
}

fn follow(backlog: List(String), out_counter, paths) {
  case backlog {
    [] -> out_counter
    [first, ..rest] ->
      case first {
        "out" -> follow(rest, out_counter + 1, paths)
        _ -> {
          let connected =
            dict.get(paths, first)
            |> result.unwrap([])
          follow(list.append(connected, rest), out_counter, paths)
        }
      }
  }
}

fn parse(input) -> Dict(String, List(String)) {
  {
    use line <- list.map(string.split(input, on: "\n"))
    let assert Ok(#(k, vals_str)) = string.split_once(line, on: ": ")
    #(k, string.split(vals_str, on: " "))
  }
  |> dict.from_list()
}
