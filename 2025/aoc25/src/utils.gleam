import gleam/result
import gleam/string
import simplifile

pub fn panic_on_error(result: Result(a, b), msg: String) -> a {
  result.lazy_unwrap(result, fn() { panic as msg })
}

pub fn lines(filename: String) -> List(String) {
  filename
  |> simplifile.read()
  |> panic_on_error("Failed to read " <> filename)
  |> string.trim_end()
  |> string.split("\n")
}
