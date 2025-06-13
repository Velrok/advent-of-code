import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

type Container {
  Container(id: Int, capacity: Int)
}

pub fn main() {
  let containers = case "inputs/day17" |> simplifile.read() {
    Error(_) -> panic as "cant read inputs/day17"
    Ok(content) ->
      content
      |> string.split(on: "\n")
      |> list.filter(fn(x) { x != "" })
      |> list.index_map(fn(item, index) {
        Container(
          index,
          item
            |> int.parse()
            |> result.lazy_unwrap(fn() {
              let msg = "can't parse pack capacity: `" <> item <> "`"
              panic as msg
            }),
        )
      })
  }

  part1(containers) |> int.to_string |> string.append(" <- part1") |> io.println
  part2(containers) |> int.to_string |> string.append(" <- part2") |> io.println
}

fn valid_combinations(containers: List(Container)) -> List(List(Container)) {
  let lengths = list.range(1, list.length(containers))

  list.flat_map(lengths, list.combinations(containers, _))
  |> list.filter(fn(containers) {
    let total_capacity =
      containers
      |> list.map(fn(c) { c.capacity })
      |> list.fold(0, int.add)
    total_capacity == 150
  })
}

fn part1(containers: List(Container)) -> Int {
  valid_combinations(containers) |> list.length
}

fn part2(containers: List(Container)) -> Int {
  let valid_combinations = valid_combinations(containers)

  let min_no_of =
    valid_combinations
    |> list.map(list.length)
    |> list.reduce(int.min)
    |> result.lazy_unwrap(fn() { panic as "failed to reduce" })

  valid_combinations
  |> list.filter(fn(l) { list.length(l) == min_no_of })
  |> list.length()
}
