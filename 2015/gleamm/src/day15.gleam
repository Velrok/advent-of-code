import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import gleam/result
import simplifile

pub fn main() {
  let assert Ok(input) = simplifile.read("./inputs/day15")
  let assert Ok(re) =
    regexp.from_string(
      "(\\w+): capacity (-?\\d+), durability (-?\\d+), flavor (-?\\d+), texture (-?\\d+), calories (-?\\d+)",
    )
  let ingredients =
    regexp.scan(re, input)
    |> list.map(ingredient_from_match)
    |> echo

  echo pick_best(ingredients:, so_far: [], remaining: 100)
}

fn pick_best(
  ingredients options: List(Ingredient),
  so_far basket: List(Ingredient),
  remaining left: Int,
) -> Int {
  case left {
    0 ->
      [score(basket), 0]
      |> list.max(int.compare)
      |> result.lazy_unwrap(fn() { panic })
      |> echo
    _ ->
      list.map(options, fn(choosen_ingredient) {
        pick_best(
          ingredients: options,
          so_far: list.append(basket, [choosen_ingredient]),
          remaining: left - 1,
        )
      })
      |> list.max(int.compare)
      |> result.lazy_unwrap(fn() { panic })
  }
}

fn score(basket: List(Ingredient)) -> Int {
  [
    list.map(basket, fn(i) { i.capacity }) |> list.fold(0, int.add),
    list.map(basket, fn(i) { i.durability }) |> list.fold(0, int.add),
    list.map(basket, fn(i) { i.flavor }) |> list.fold(0, int.add),
    list.map(basket, fn(i) { i.texture }) |> list.fold(0, int.add),
  ]
  |> list.fold(1, int.multiply)
}

pub type Ingredient {
  Ingredient(
    name: String,
    capacity: Int,
    durability: Int,
    flavor: Int,
    texture: Int,
    calories: Int,
  )
}

fn ingredient_from_match(match: regexp.Match) -> Ingredient {
  case match.submatches {
    [Some(name), ..rest] -> {
      let assert [
        Ok(capacity),
        Ok(durability),
        Ok(flavor),
        Ok(texture),
        Ok(calories),
      ] =
        rest
        |> list.map(option.to_result(_, Nil))
        |> list.map(result.try(_, int.parse))
      Ingredient(name:, capacity:, durability:, flavor:, texture:, calories:)
    }
    _ -> panic
  }
}
// fn pick_on(so_far, left) {
//   todo
//   // if left 0; score(so_far)
//   // max(
//   // otherwise pick_on(so_far + ing1, left -1)
//   // otherwise pick_on(so_far + ing2, left -1)
//   // otherwise pick_on(so_far + ing3, left -1)
//   // otherwise pick_on(so_far + ing4, left -1)
//   // )
// }
