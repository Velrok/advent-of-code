import vector2d.{type Vec, Vec}
import utils
import gleam/string
import gleam/list
import gleam/io.{debug}
import gleam/int
import gleam/result
import gleam/option
import gleam/regexp
import simplifile

pub fn main() {
  // The robots outside the actual bathroom are in a space which is
  //101 tiles wide and 103 tiles tall.
  // However, in this example, the robots are in a space which is only
  // 11 tiles wide and 7 tiles tall.
  let example =
    "p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3"

  let assert Ok(input) = simplifile.read(from: "inputs/day14.input")
  let example_just_one = "p=2,4 v=2,-3"

  let robots =
    parse(
      input
      |> string.trim,
    )
  part01(robots)
}

fn part02(robots: List(Robot)) {
  // idea: tree is found iff
  // quad 1 matches quad 2 mirrored on the Y axis
  // and
  // quad 3 matches quad 4 mirrored on the Y axis
  todo
}

fn part01(robots: List(Robot)) {
  // let wide = 11
  // let tall = 7
  let wide = 101
  let tall = 103

  let robots =
    utils.simulate(100, robots, fn(robots) {
      robots
      |> list.map(move(wide, tall, _))
    })
    |> print_field(wide, tall)

  let quad1 = utils.grid_positions(list.range(0, 50), list.range(0, 49))
  let quad2 = utils.grid_positions(list.range(0, 50), list.range(51, 100))
  let quad3 = utils.grid_positions(list.range(52, 102), list.range(0, 49))
  let quad4 = utils.grid_positions(list.range(52, 102), list.range(51, 100))

  [quad1, quad2, quad3, quad4]
  |> list.map(fn(quad) {
    quad
    |> list.map(fn(pos) { robot_count(robots, vector2d.from_pair(pos)) })
    |> int.sum()
    |> io.debug
  })
  |> list.reduce(int.multiply)
  |> io.debug
}

fn move(wide: Int, tall: Int, robot: Robot) -> Robot {
  let wrapper = Vec(wide, tall)
  Robot(
    pos: robot.pos
      |> vector2d.add(robot.vel)
      |> vector2d.wrap(wrapper),
    vel: robot.vel,
  )
}

pub type Robot {
  Robot(pos: Vec, vel: Vec)
}

fn parse(s: String) {
  s
  |> string.split("\n")
  |> list.map(parse_line)
}

fn parse_line(line: String) -> Robot {
  let assert Ok(re) =
    regexp.from_string("p=([\\d-]*),([\\d-]*) v=([\\d-]*),([\\d-]*)")
  let assert Ok(m) =
    regexp.scan(re, line)
    |> list.first

  let assert [px, py, vx, vy] =
    m.submatches
    |> option.values
    |> list.map(int.parse)
    |> result.values

  Robot(pos: Vec(px, py), vel: Vec(vx, vy))
}

fn print_field(robots: List(Robot), wide, tall) -> List(Robot) {
  let rows: List(String) =
    list.range(0, tall - 1)
    |> list.map(fn(y) {
      list.range(0, wide - 1)
      |> list.map(fn(x) {
        case robot_count(robots, Vec(x, y)) {
          0 -> "."
          x -> int.to_string(x)
        }
      })
      |> string.join("")
    })

  rows
  |> string.join("\n")
  |> io.println

  io.println("")

  robots
}

fn robot_count(robots: List(Robot), at: Vec) -> Int {
  list.filter(robots, fn(robot) { robot.pos == at })
  |> list.length()
}
