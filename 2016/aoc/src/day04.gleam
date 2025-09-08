import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type RoomDescription {
  RoomDescription(letters: String, sector_id: Int, checksum: String)
}

pub fn main() {
  let filename = "inputs/day04.example"
  filename
  |> simplifile.read()
  |> result.lazy_unwrap(fn() {
    echo filename
    panic as "cant read file"
  })
  |> string.split(on: "\n")
  |> list.filter(fn(s) { !string.is_empty(s) })
  |> list.map(parse_room_desc)
  |> list.filter(real_room)
}

fn real_room(_room_description: RoomDescription) -> Bool {
  // Implementation would check if room is valid based on checksum
  // For now, return true to allow compilation
  True
}

fn parse_room_desc(line) -> RoomDescription {
  case
    string.split(line, on: "-")
    |> list.reverse()
  {
    [sec_and_checksum, ..rest] -> {
      let room_name = string.join(rest, "")
      case string.split(sec_and_checksum, on: "[") {
        [sec, checksum_with_closing_braket] -> {
          let assert Ok(sec_no) = int.parse(sec)
          let checksum = string.drop_right(checksum_with_closing_braket, 1)
          RoomDescription(
            letters: room_name,
            sector_id: sec_no,
            checksum: checksum,
          )
        }
        _ -> panic
      }
    }
    _ -> {
      echo line
      panic as "invalid line"
    }
  }
}
