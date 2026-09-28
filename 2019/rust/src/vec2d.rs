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

pub fn bounds<'a>(points: impl IntoIterator<Item = &'a Vec2D>) -> (Inner, Inner, Inner, Inner) {
    let mut min_x = Inner::MAX;
    let mut max_x = Inner::MIN;
    let mut min_y = Inner::MAX;
    let mut max_y = Inner::MIN;

    for point in points {
        min_x = min_x.min(point.x());
        max_x = max_x.max(point.x());

        min_y = min_y.min(point.y());
        max_y = max_y.max(point.y());
    }

    (min_x, max_x, min_y, max_y)
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
