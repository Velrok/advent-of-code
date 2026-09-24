use std::ops::{Add, AddAssign};

type Inner = i64;

#[derive(Clone, Copy, Eq, Hash, PartialEq, Default, Debug)]
pub struct Vec2D(Inner, Inner);

impl Vec2D {
    pub fn new(x: Inner, y: Inner) -> Self {
        Self(x, y)
    }

    pub fn x(&self) -> Inner {
        self.0
    }

    pub fn y(&self) -> Inner {
        self.1
    }

    pub fn up() -> Self {
        Self(0, 1)
    }

    pub fn down() -> Self {
        Self(0, -1)
    }

    pub fn left() -> Self {
        Self(-1, 0)
    }

    pub fn right() -> Self {
        Self(1, 0)
    }
}

impl Add for Vec2D {
    type Output = Self;

    fn add(self, other: Self) -> Self::Output {
        Self(self.0 + other.0, self.1 + other.1)
    }
}

impl AddAssign for Vec2D {
    fn add_assign(&mut self, other: Self) {
        self.0 += other.0;
        self.1 += other.1;
    }
}
