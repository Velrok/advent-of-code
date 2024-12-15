pub type Vec {
  Vec(x: Int, y: Int)
}

pub fn add(a: Vec, b: Vec) -> Vec {
  Vec(a.x + b.x, a.y + b.y)
}

pub fn wrap(a: Vec, b: Vec) -> Vec {
  Vec(a.x % b.x, a.y % b.y)
}
