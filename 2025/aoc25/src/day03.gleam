import gleam/int
import gleam/list
import gleam/order
import gleam/string
import iv.{type Array}
import utils

type Bank {
  Bank(batteries: Array(Int))
}

pub fn main() {
  // The total output joltage is the sum of the maximum joltage from each bank,
  echo utils.lines("inputs/day03")
    |> list.map(parse_bank)
    |> list.map(max_joltage)
    |> list.reduce(int.add)
}

fn parse_bank(line: String) -> Bank {
  Bank(
    batteries: line
    |> string.trim_end()
    |> string.to_graphemes()
    |> list.map(fn(c) {
      int.parse(c)
      |> utils.panic_on_error("cant parse " <> " as int")
    })
    |> iv.from_list(),
  )
}

fn max_joltage(bank: Bank) -> Int {
  let batteries = bank.batteries
  let size = iv.length(batteries) - 1

  let #(first_digit, index) =
    batteries
    |> iv.slice(start: 0, size:)
    |> utils.panic_on_error("Batteries Array is empty")
    |> max_by(int.compare)
    |> utils.panic_on_error("failed to find max_by")

  let #(second_digit, _) =
    batteries
    |> iv.slice(start: index + 1, size: size - index)
    |> utils.panic_on_error("Batteries Array is empty")
    |> max_by(int.compare)
    |> utils.panic_on_error("failed to find max_by")

  first_digit * 10 + second_digit
}

fn max_by(
  arr: Array(a),
  comp: fn(a, a) -> order.Order,
) -> Result(#(a, Int), Nil) {
  case iv.first(arr) {
    Error(n) -> Error(n)
    Ok(first) -> {
      case iv.rest(arr) {
        Error(_) -> Ok(#(first, 0))
        Ok(tail) ->
          Ok(
            iv.index_fold(tail, #(first, 0), fn(agg, item, index) {
              let #(biggest, _) = agg
              case comp(biggest, item) {
                order.Lt -> #(item, index + 1)
                _ -> agg
              }
            }),
          )
      }
    }
  }
}
