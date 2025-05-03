import gleam/dict
import gleam/function
import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import gleam/result
import utils

pub fn main() {
  // part01()
  part02()
}

fn part01() {
  // utils.lines("./inputs/day14.example")
  utils.lines("./inputs/day14")
  |> list.map(reindeer_from_string)
  |> list.map(reindeer_distance_after_time(_, 2503))
  |> echo
  |> list.max(int.compare)
  |> echo
}

fn part02() {
  // utils.lines("./inputs/day14.example")
  let reindeer =
    utils.lines("./inputs/day14")
    |> list.map(reindeer_from_string)

  list.range(1, 2503)
  |> list.flat_map(leaders_at(reindeer, _))
  |> list.group(function.identity)
  |> dict.map_values(fn(_r, l) { list.length(l) })
  |> dict.fold(0, fn(acc, _r, dist) { int.max(acc, dist) })
  |> echo
}

fn leaders_at(reindeer: List(Reindeer), second: Int) -> List(Reindeer) {
  let max_dist =
    reindeer
    |> list.map(reindeer_distance_after_time(_, second))
    |> list.max(int.compare)
    |> result.lazy_unwrap(fn() { panic })

  reindeer
  |> list.filter(fn(r) { reindeer_distance_after_time(r, second) == max_dist })
}

fn reindeer_distance_after_time(reindeer: Reindeer, duration: Int) -> Int {
  let assert Ok(no_cycles) = int.divide(duration, reindeer.cycle_time)
  let cycle_distance = reindeer.speed * reindeer.sprint_duration
  let assert Ok(remaining_cycle) = int.modulo(duration, reindeer.cycle_time)
  let remaining_sprint = int.min(remaining_cycle, reindeer.sprint_duration)
  let last_hura = remaining_sprint * reindeer.speed
  cycle_distance * no_cycles + last_hura
}

pub type Reindeer {
  Reindeer(
    name: String,
    speed: Int,
    sprint_duration: Int,
    rest_duration: Int,
    cycle_time: Int,
  )
}

fn reindeer_from_string(str: String) -> Reindeer {
  let assert Ok(re) =
    regexp.from_string(
      "(\\w+) can fly (\\d+) km/s for (\\d+) seconds, but then must rest for (\\d+) seconds.",
    )
  let assert Ok(match) =
    regexp.scan(re, str)
    |> list.first

  let assert [Some(name), Some(speed_str), Some(sprint_str), Some(rest_str)] =
    match.submatches

  let assert Ok(speed) = int.parse(speed_str)
  let assert Ok(sprint_duration) = int.parse(sprint_str)
  let assert Ok(rest_duration) = int.parse(rest_str)

  Reindeer(
    name:,
    speed:,
    sprint_duration:,
    rest_duration:,
    cycle_time: sprint_duration + rest_duration,
  )
}
