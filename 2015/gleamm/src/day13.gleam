import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import simplifile

// import utils

pub type Node {
  Node(person: String, gain: Int, neighbour: String)
}

pub fn main() {
  // let assert Ok(input) = simplifile.read("./inputs/day13.example")
  let assert Ok(input) = simplifile.read("./inputs/day13")
  let assert Ok(re) =
    regexp.from_string(
      "(\\w+) would (gain|lose) (-?\\d+) happiness units by sitting next to (\\w+).",
    )
  let matches = regexp.scan(re, input)
  let nodes = matches |> list.map(node_from_match)

  // echo part1(nodes)
  echo part2(nodes)
}

fn part1(nodes: List(Node)) {
  let people = extract_people(nodes)
  let seating_orders = list.permutations(people)
  seating_orders |> list.map(score(nodes, _)) |> list.max(int.compare)
}

fn part2(nodes: List(Node)) {
  let others_and_me =
    nodes
    |> list.append(
      extract_people(nodes)
      |> list.map(Node(person: "me", neighbour: _, gain: 0)),
    )
    |> list.append(
      extract_people(nodes)
      |> list.map(Node(person: _, neighbour: "me", gain: 0)),
    )

  part1(others_and_me)
}

fn extract_people(nodes: List(Node)) {
  list.map(nodes, fn(n) { n.person }) |> list.unique()
}

fn score(nodes: List(Node), seating_arrangement: List(String)) -> Int {
  seating_arrangement
  |> list.index_map(fn(_person, index) {
    let left = at(seating_arrangement, index - 1)
    let person = at(seating_arrangement, index)
    let right = at(seating_arrangement, index + 1)

    neighbour_score(nodes, person, left) + neighbour_score(nodes, person, right)
  })
  |> list.fold(0, int.add)
}

fn neighbour_score(nodes: List(Node), person: String, neighbour: String) -> Int {
  let assert Ok(match) =
    nodes
    |> list.filter(fn(n) { n.person == person && n.neighbour == neighbour })
    |> list.first()

  match.gain
}

fn at(l: List(String), idx: Int) -> String {
  let assert Ok(idx) = int.modulo(idx, list.length(l))
  let assert Ok(element) = l |> list.drop(idx) |> list.first()
  element
}

fn node_from_match(match: regexp.Match) -> Node {
  let assert [Some(person), Some(change), Some(amount_str), Some(neighbour)] =
    match.submatches
  let assert Ok(amount) = int.parse(amount_str)

  let gain = case change {
    "gain" -> amount
    "lose" -> -amount
    _ -> panic
  }

  Node(person: person, neighbour: neighbour, gain: gain)
}
