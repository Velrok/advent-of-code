import gleam/io.{debug}
import gleam/list
import gleam/set
import gleam/dict
import gleam/string
import utils

// A nice string is one with all of the following properties:
//
// ✅ It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
// ✅ It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
// ✅ It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
pub fn is_nice(line: String) {
  !is_naught(line) && has_double_letter(line) && has_three_vowels(line)
}

pub fn has_three_vowels(line: String) {
  let is_vowel = fn(character) { string.contains("aeiou", character) }
  let characters = string.split(line, on: "")
  list.count(characters, is_vowel) >= 3
}

pub fn has_double_letter(line: String) {
  let doubles =
    string.split(line, on: "")
    |> list.window_by_2
    |> list.count(fn(pair) {
      let #(a, b) = pair
      a == b
    })
  doubles > 0
}

pub fn is_naught(line: String) {
  string.contains(does: line, contain: "ab")
  || string.contains(does: line, contain: "cd")
  || string.contains(does: line, contain: "pq")
  || string.contains(does: line, contain: "xy")
}

pub fn p1() {
  utils.lines(filename: "./inputs/05.p1")
  |> list.count(is_nice)
}

// It contains a pair of any two letters that appears at least twice in the string without overlapping,
// like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
// It contains at least one letter which repeats with exactly one letter between them, like xyx,
// abcdefeghi (efe), or even aaa.
fn is_nice_2(line: String) {
  has_non_overlapping_pairs(line)
}

pub type CharPair {
  CharPair(
    first_char: String,
    first_idx: Int,
    second_char: String,
    second_idx: Int,
  )
}

fn has_non_overlapping_pairs(line: String) {
  string.split(line, on: "")
  |> list.index_map(fn(char, i) { #(char, i) })
  |> list.window_by_2
  |> list.map(fn(el) {
    let #(#(first_char, first_idx), #(second_char, second_idx)) = el
    CharPair(
      first_char: first_char,
      first_idx: first_idx,
      second_char: second_char,
      second_idx: second_idx,
    )
  })
  |> list.group(by: fn(pair: CharPair) { #(pair.first_char, pair.second_char) })
  |> dict.filter(fn(_k, v) { list.length(v) > 1 })
  |> dict.filter(fn(_k, pairs) {
    pairs
    |> list.combinations(2)
    |> list.filter(fn(pairs) {
      let assert [p1, p2] = pairs
      set.intersection(
        set.from_list([p1.first_idx, p1.second_idx]),
        set.from_list([p2.first_idx, p2.second_idx]),
      )
      |> set.is_empty
    })
    |> list.length
    > 1
  })
}

pub fn p2() {
  todo
  // utils.lines(filename: "./inputs/05.p1")
  // |> list.count(is_nice_2)
}

pub fn main() {
  debug(has_non_overlapping_pairs("aaaabbc"))
}
// [
// CharPair("a", 2, "a", 3),
// CharPair("a", 1, "a", 2),
// CharPair("a", 0, "a", 1)
// ]
