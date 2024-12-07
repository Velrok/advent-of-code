import gleam/string
import gleam/int
import gleam/list
import gleam/result
import gleam/function.{identity}

pub fn main() {
  let example =
    "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"

  let assert [left, right] = string.split(example, ":")

  let test_value = int.parse(left)
  let numbers =
    right
    |> string.trim()
    |> string.split(" ")
    |> list.map(int.parse)
    |> result.values()
}
