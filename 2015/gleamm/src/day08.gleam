import gleam/int
import gleam/list

// import gleam/result
import gleam/string.{
  from_utf_codepoints, inspect, to_utf_codepoints, utf_codepoint,
}
import utils

fn length_diff(line: String) -> Int {
  let excluded_codepoints = codepoints()
  let line = string.trim(line)
  let original_len = string.length(line)
  let decoded_len =
    to_utf_codepoints(line)
    |> list.filter(fn(codepoint) {
      !list.contains(excluded_codepoints, codepoint)
    })
    |> list.length
  echo #("line", line)
  echo #("original", original_len)
  echo #("decoded", decoded_len)
  original_len - decoded_len
}

fn test_input() {
  utils.lines("inputs/08.test")
  |> list.map(length_diff)
}

pub fn part1() {
  utils.lines("inputs/08.p1")
  |> list.map(length_diff)
  |> list.reduce(int.add)
}

pub fn part2() {
  todo
}

fn codepoints() -> List(UtfCodepoint) {
  todo
  // let extras =
  //   "\"\\"
  //   |> to_utf_codepoints
  // // a-z
  // let az =
  //   list.range(0x61, 0x7A)
  //   |> list.map(utf_codepoint)
  //   |> result.values
  // // 0x41, 0x5A // A-Z
  // let az_cap =
  //   list.range(0x41, 0x5A)
  //   |> list.map(utf_codepoint)
  //   |> result.values
  // let ascii_codes =
  //   list.range(0, 127)
  //   |> list.map(fn(asci) { "\\x" <> int.to_string(asci) })
  //   |> list.map(to_utf_codepoints)
  //   |> list.map(list.first)
  //   |> result.values
  // list.concat([ascii_codes, extras])
}

// gleam run -m day01
pub fn main() {
  // echo codepoints()
  echo test_input()
  // echo part1()
  // echo part2()
}
