import gleam/dict
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import gleam/result
import gleam/string

// import simplifile

type Substibutions =
  dict.Dict(String, List(String))

pub fn splits(content: String, sep: String) {
  let parts = string.split(content, sep)
  list.index_map(parts, fn(_, index) {
    let prefix =
      list.take(parts, index)
      |> string.join(sep)
    let suffix =
      list.drop(parts, index)
      |> string.join(sep)
    #(prefix, suffix)
  })
  |> list.rest
  |> result.lazy_unwrap(fn() { panic })
}

pub fn main() {
  // let assert Ok(input) = simplifile.read("./inputs/day19.example")
  // TODO: also parse the actual string to operate on (last line)
  // let subs = parse(input)
  // part01()
  // for each substibution run this and collect all the results into a set
  echo splits("HOH", "H")
    |> list.map(fn(pre_and_suf) {
      let #(pre, suf) = pre_and_suf
      string.append(pre, "HO")
      |> string.append(suf)
    })
  // then we can just return the size of the set
}

pub fn parse(input: String) -> Substibutions {
  let assert Ok(re) = regexp.from_string("(\\w+) => (\\w+)")
  regexp.scan(re, input)
  |> list.map(fn(match) {
    case match.submatches {
      [Some(from), Some(to)] -> #(from, to)
      _ -> panic
    }
  })
  |> list.fold(dict.new(), fn(agg, next) {
    let #(from, to) = next
    dict.upsert(agg, from, fn(val) {
      case val {
        Some(subs) -> list.append(subs, [to])
        option.None -> [to]
      }
    })
  })
}
