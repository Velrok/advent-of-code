import gleam/result

pub fn panic_on_error(result: Result(a, b), msg: String) -> a {
  result.lazy_unwrap(result, fn() { panic as msg })
}
