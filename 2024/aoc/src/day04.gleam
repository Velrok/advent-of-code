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

fn kernel_matches(input_cutout, kernel: Kernel) -> Bool {
  let results =
    list.map2(kernel.matrix, input_cutout, with: fn(kernel_row, input_row) {
      list.map2(kernel_row, input_row, with: fn(kernel_cell, input_cell) {
        case kernel_cell {
          "." -> True
          x -> x == input_cell
        }
      })
    })

  results
  |> list.flatten
  |> list.all(is_true)
}

fn scan_kernel(input, kernel: Kernel) {
  let #(input_width, input_height) = matrix_dimension(input)
  let #(kernel_width, kernel_height) = matrix_dimension(kernel.matrix)

  range(0, input_height - kernel_height)
  |> map(fn(y) {
    // each row
    range(0, input_width - kernel_width)
    |> map(fn(x) {
      // each cell
      let input_cutout =
        list.split(input, y)
        |> pair.second
        |> list.take(kernel_height)
        |> list.map(fn(input_row) {
          input_row
          |> list.split(x)
          |> pair.second
          |> list.take(kernel_width)
        })
      kernel_matches(input_cutout, kernel)
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
    make_kernel("XMAS"),
    make_kernel("SAMX"),
    make_kernel(
      "X
M
A
S",
    ),
    make_kernel(
      "S
A
M
X",
    ),
    make_kernel(
      "S...
.A..
..M.
...X",
    ),
    make_kernel(
      "...S
..A.
.M..
X...",
    ),
    make_kernel(
      "X...
.M..
..A.
...S",
    ),
    make_kernel(
      "...X
..M.
.A..
S...",
    ),
  ]
  |> list.map(fn(kernel) {
    debug(kernel)
    scan_kernel(input, kernel)
    |> list.filter(is_true)
    |> list.length
    |> debug
  })
  |> int.sum
}

type Kernel {
  Kernel(matrix: List(List(String)))
}

fn make_kernel(str) {
  Kernel(char_matrix(str))
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
  let puzzle_input = example

  let input =
    puzzle_input
    |> char_matrix

  part1(input)
  |> debug
}
