import gleam/bit_array
import gleam/crypto.{Md5}
import gleam/int
import gleam/string

fn md5_hash(input: String) -> String {
  bit_array.from_string(input)
  |> crypto.hash(Md5, _)
  |> bit_array.base16_encode
}

fn solver(input: String, counter: Int, prefix: String) -> Int {
  let hash = md5_hash(input <> int.to_string(counter))
  case string.starts_with(hash, prefix) {
    True -> counter
    False -> solver(input, counter + 1, prefix)
  }
}

pub fn part1() {
  solver("bgvyzdsv", 1, "00000")
}

fn part2() {
  solver("bgvyzdsv", 1, "000000")
}

// gleam run -m day02
pub fn main() {
  echo part2()
}
