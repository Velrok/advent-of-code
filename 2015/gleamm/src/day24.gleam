// Step 1: get the total weight TO
// -> each group need 1/3 * TO
// order is irrelevant

import gleam/int
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let a = 2
  let packages =
    result.lazy_unwrap(simplifile.read(from: "./input/day24"), fn() {
      panic as "cant read input file"
    })
    |> string.trim()
    |> string.split(on: "\n")
    |> list.map(int.parse)
    |> result.values()
    |> list.reverse()
  // they are pre sorted by we want largest first

  let total_weight = weight_packages(packages)
  let target_weight = total_weight / 4
  let best_fit =
    find_valid_combinations(target_weight, packages, 2)
    |> list.sort(quantum_entangement_order)
    |> list.first
    |> result.lazy_unwrap(fn() { panic as "no best fit" })
  echo best_fit
  echo quantum_entangement(best_fit)
}

fn quantum_entangement_order(list: List(Int), list_2: List(Int)) -> order.Order {
  let qe_one = quantum_entangement(list)
  let qe_two = quantum_entangement(list_2)
  int.compare(qe_one, qe_two)
}

fn quantum_entangement(packages: List(Int)) -> Int {
  list.fold(packages, 1, int.multiply)
}

fn weight_packages(packages: List(Int)) -> Int {
  list.fold(packages, 0, int.add)
}

fn find_valid_combinations(
  target_weight: Int,
  packages: List(Int),
  length: Int,
) -> List(List(Int)) {
  let valid_combinations =
    packages
    |> list.combinations(length)
    |> list.filter(fn(combinations) {
      weight_packages(combinations) == target_weight
    })

  case list.is_empty(valid_combinations) {
    False -> valid_combinations
    True -> {
      case length + 1 == list.length(packages) {
        False -> find_valid_combinations(target_weight, packages, length + 1)
        True -> panic as "List exhaused"
      }
    }
  }
}
