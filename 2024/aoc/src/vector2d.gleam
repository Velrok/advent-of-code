import gleam/int

pub type Vec {
  Vec(x: Int, y: Int)
}

pub fn from_pair(pair: #(Int, Int)) -> Vec {
  let #(x, y) = pair
  Vec(x, y)
}

pub fn add(a: Vec, b: Vec) -> Vec {
  Vec(a.x + b.x, a.y + b.y)
}

pub fn wrap(a: Vec, b: Vec) -> Vec {
  let assert Ok(x) = int.modulo(a.x, b.x)
  let assert Ok(y) = int.modulo(a.y, b.y)
  Vec(x, y)
}
