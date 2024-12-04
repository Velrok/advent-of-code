import gleam/int
import gleam/io.{debug}
import gleam/list.{first, map, range}
import gleam/pair
import simplifile

// import gleam/regexp
import gleam/string

// import utils

fn char_matrix(input) {
  string.split(input, "\n")
  |> list.map(string.split(_, ""))
}

fn matrix_dimension(m) {
  let assert Ok(first_row) = first(m)
  #(list.length(first_row), list.length(m))
}

fn is_true(x) {
  x == True
}

fn kernal_matches(input_cutout, kernal: Kernal) -> Bool {
  let results =
    list.map2(kernal.matrix, input_cutout, with: fn(kernal_row, input_row) {
      list.map2(kernal_row, input_row, with: fn(kernal_cell, input_cell) {
        case kernal_cell {
          "." -> True
          x -> x == input_cell
        }
      })
    })

  results
  |> list.flatten
  |> list.all(is_true)
}

fn scan_kernal(input, kernal: Kernal) {
  let #(input_width, input_height) = matrix_dimension(input)
  let #(kernal_width, kernal_height) = matrix_dimension(kernal.matrix)

  range(0, input_height - kernal_height)
  |> map(fn(y) {
    // each row
    range(0, input_width - kernal_width)
    |> map(fn(x) {
      // each cell
      let input_cutout =
        list.split(input, y)
        |> pair.second
        |> list.take(kernal_height)
        |> list.map(fn(input_row) {
          input_row |> list.split(x) |> pair.second |> list.take(kernal_width)
        })
      kernal_matches(input_cutout, kernal)
    })
  })
  |> list.flatten
}

// pub fn transpose(input) {
//   list.transpose(char_matrix(input))
//   |> list.map(string.join(_, ""))
//   |> string.join("\n")
// }

pub fn part1(input) {
  [
    make_kernal("XMAS"),
    make_kernal("SAMX"),
    make_kernal(
      "X
M
A
S",
    ),
    make_kernal(
      "S
A
M
X",
    ),
    make_kernal(
      "S...
.A..
..M.
...X",
    ),
    make_kernal(
      "...S
..A.
.M..
X...",
    ),
    make_kernal(
      "X...
.M..
..A.
...S",
    ),
    make_kernal(
      "...X
..M.
.A..
S...",
    ),
  ]
  |> list.map(fn(kernal) {
    debug("kernal")
    debug(kernal)
    scan_kernal(input, kernal)
    |> list.filter(is_true)
    |> list.length
    |> debug
  })
  |> int.sum
}

type Kernal {
  Kernal(matrix: List(List(String)))
}

fn make_kernal(str) {
  Kernal(char_matrix(str))
}

pub fn main() {
  // let input =
  //   "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  let example =
    "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

  let testing =
    "..X...
.SAMX.
.A..A.
XMAS.S
.X...."

  let assert Ok(puzzle_input) = simplifile.read(from: "inputs/day04.input")

  let input = puzzle_input |> char_matrix

  part1(input) |> debug
}
