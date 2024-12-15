import vector2d.{type Vec, Vec, add, wrap}
import gleeunit/should

pub fn add_test() {
  add(Vec(0, 0), Vec(1, 1))
  |> should.equal(Vec(1, 1))

  add(Vec(1, 2), Vec(2, 2))
  |> should.equal(Vec(3, 4))

  add(Vec(1, 2), Vec(-1, -2))
  |> should.equal(Vec(0, 0))

  add(Vec(0, 0), Vec(-1, -2))
  |> should.equal(Vec(-1, -2))
}

pub fn wrap_test() {
  wrap(Vec(3, 3), Vec(3, 3))
  |> should.equal(Vec(0, 0))

  wrap(Vec(2, 2), Vec(3, 3))
  |> should.equal(Vec(2, 2))

  wrap(Vec(4, 4), Vec(3, 3))
  |> should.equal(Vec(1, 1))

  wrap(Vec(-1, -1), Vec(3, 3))
  |> should.equal(Vec(2, 2))
}
