import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  // let assert Ok(content) = simplifile.read("inputs/day11.example2")
  let assert Ok(content) = simplifile.read("inputs/day11")
  let paths =
    content
    |> string.trim_end()
    |> parse()
  // echo part1(["you"], 0, paths)
  echo part2(["dac", "fft"], "svr", paths)
}

fn part2(
  outstanding_required: List(String),
  current: String,
  paths: Dict(String, List(String)),
) -> Int {
  // ☑️TODO: find valid paths from current to out
  // valid paths are the ones where outstanding_required and up empty
  todo
}

fn part1(backlog: List(String), out_counter, paths) {
  case backlog {
    [] -> out_counter
    [first, ..rest] ->
      case first {
        "out" -> part1(rest, out_counter + 1, paths)
        _ -> {
          let connected =
            dict.get(paths, first)
            |> result.unwrap([])
          part1(list.append(connected, rest), out_counter, paths)
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
