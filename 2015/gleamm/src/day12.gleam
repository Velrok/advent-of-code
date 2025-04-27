import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  todo
  // let assert Ok(puzzle_input) = simplifile.read("./inputs/day12.json")
  // echo part2(puzzle_input)
}
// fn part1(puzzle_input) -> Int {
//   let assert Ok(number_re) = regexp.from_string("-?\\d+")
//
//   regexp.scan(number_re, puzzle_input)
//   |> list.map(fn(m) { m.content |> int.parse })
//   |> result.values
//   |> int.sum
// }
//
// fn part2(puzzle_input) -> Int {
//   let filtered_input = strip_red_values(puzzle_input)
//   io.print(filtered_input)
//
//   part1(filtered_input)
// }
//
// type Ranges {
//   Ranges(openings: List(Int), closings: List(Int))
// }
//
// fn new_ranges() -> Ranges {
//   Ranges(openings: [], closings: [])
// }
//
// fn start_end_for_index(ranges: Ranges, index: Int) -> #(Int, Int) {
//   let assert Ok(start) =
//     list.take_while(ranges.openings, fn(x) { x <= index })
//     |> list.first
//   let assert Ok(end) =
//     list.take_while(ranges.closings, fn(x) { index <= x })
//     |> list.first
//   #(start, end)
// }
//
// fn strip_red_values(puzzle_input: String) {
//   let ranges =
//     puzzle_input
//     |> string.split("")
//     |> list.index_fold(new_ranges(), fn(agg, char, idx) {
//       case char {
//         "{" -> Ranges(..agg, openings: list.append(agg.openings, [idx]))
//         "}" -> Ranges(..agg, closings: list.append(agg.closings, [idx]))
//         _ -> agg
//       }
//     })
// }
