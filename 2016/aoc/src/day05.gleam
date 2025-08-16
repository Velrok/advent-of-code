import gleam/bit_array
import gleam/crypto
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

pub fn main() {
  let door_id = "cxdnnyjw"
  // echo part01(door_id)
  echo part02(door_id)
}

fn part02(door_id: String) -> String {
  hack_door_2(door_id, 0, list.repeat(None, 8))
  |> string.concat()
}

fn part01(door_id: String) -> String {
  hack_door_1(door_id, 0, [])
  |> string.concat()
}

fn hack_door_1(
  door_id: String,
  idx: Int,
  password: List(String),
) -> List(String) {
  let hash =
    crypto.hash(
      crypto.Md5,
      bit_array.from_string(door_id <> int.to_string(idx)),
    )
    |> bit_array.base16_encode
  let is_interesting = string.starts_with(hash, "00000")
  case is_interesting {
    False -> hack_door_1(door_id, idx + 1, password)
    True -> {
      let pw =
        password
        |> list.append([
          hash
          |> string.slice(at_index: 5, length: 1),
        ])
      echo pw
      let is_complete = list.length(pw) == 8
      case is_complete {
        False -> hack_door_1(door_id, idx + 1, pw)
        True -> pw
      }
    }
  }
}

fn hack_door_2(
  door_id: String,
  idx: Int,
  password: List(Option(String)),
) -> List(String) {
  let hash =
    crypto.hash(
      crypto.Md5,
      bit_array.from_string(door_id <> int.to_string(idx)),
    )
    |> bit_array.base16_encode
  let is_interesting = string.starts_with(hash, "00000")
  case is_interesting {
    False -> hack_door_2(door_id, idx + 1, password)
    True -> {
      let pw_pos = hash |> string.slice(at_index: 5, length: 1)
      let valid_pos =
        list.contains(["0", "1", "2", "3", "4", "5", "6", "7"], pw_pos)
      case valid_pos {
        False -> hack_door_2(door_id, idx + 1, password)
        True -> {
          let pw_char = hash |> string.slice(at_index: 6, length: 1)
          let at =
            pw_pos
            |> int.parse
            |> result.lazy_unwrap(fn() { panic as "cant parse pw_pos as int" })
          let #(before_idx, from_idx) = list.split(password, at:)
          let assert [current, ..rest] = from_idx
          let pw = case current {
            None -> list.append(before_idx, [Some(pw_char), ..rest])
            Some(_) -> password
          }
          echo pw
          let is_complete = list.all(pw, option.is_some)
          case is_complete {
            False -> hack_door_2(door_id, idx + 1, pw)
            True -> option.values(pw)
          }
        }
      }
    }
  }
}
