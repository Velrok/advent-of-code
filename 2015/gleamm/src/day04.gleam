import gleam/io.{debug}
import gleam/bit_array.{inspect}

fn p1() {
  debug(inspect(<<8:size(8)>>))
}

fn p2() {
  todo
}

// gleam run -m day02
pub fn main() {
  debug(p1())
}
