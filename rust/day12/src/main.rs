fn main() {
    let input = include_str!("../input");
    println!("part1 -> {}", part1(input));
}

fn part1(input: &str) -> i32 {
    let instructions = parse_instructions(input);
    let mut ship = Ship::new();

    for instr in instructions {
        ship.process(&instr);
    }

    let origin = Point2D { x: 0, y: 0 };
    manhattan_dist(&origin, &ship.position)
}

#[derive(Debug)]
enum Instruction {
    N(i32),
    S(i32),
    E(i32),
    W(i32),
    L(i32),
    R(i32),
    F(i32),
}

#[derive(PartialEq, Eq, Debug, Clone, Copy)]
struct Point2D {
    x: i32,
    y: i32,
}

impl std::ops::Add for Point2D {
    type Output = Point2D;
    fn add(self: Self, p2: Self) -> Point2D {
        Point2D {
            x: self.x + p2.x,
            y: self.y + p2.y,
        }
    }
}

impl std::ops::Sub for Point2D {
    type Output = Point2D;
    fn sub(self: Self, p2: Self) -> Point2D {
        Point2D {
            x: self.x - p2.x,
            y: self.y - p2.y,
        }
    }
}

impl std::ops::Mul<i32> for Point2D {
    type Output = Point2D;
    fn mul(self: Self, rhs: i32) -> Point2D {
        Point2D {
            x: self.x * rhs,
            y: self.y * rhs,
        }
    }
}

struct Ship {
    deg: i32, // 0 means north
    position: Point2D,
}

impl Ship {
    fn new() -> Self {
        Ship {
            deg: 90,
            position: Point2D { x: 0, y: 0 },
        }
    }

    fn direction(&self) -> Point2D {
        match self.deg.rem_euclid(360) {
            0 => Point2D { x: 0, y: 1 },
            90 => Point2D { x: 1, y: 0 },
            180 => Point2D { x: 0, y: -1 },
            270 => Point2D { x: -1, y: 0 },
            _ => panic!("Cthulu is coming!!!😱 (deg: {})", self.deg),
        }
    }

    fn process(&mut self, i: &Instruction) {
        use Instruction::*;
        match i {
            N(y) => self.position = self.position + Point2D { x: 0, y: *y },
            S(y) => self.position = self.position + Point2D { x: 0, y: -1 * *y },
            E(x) => self.position = self.position + Point2D { x: *x, y: 0 },
            W(x) => self.position = self.position + Point2D { x: -1 * *x, y: 0 },
            L(d) => self.deg -= *d,
            R(d) => self.deg += *d,
            F(x) => self.position = self.position + self.direction() * *x,
        }
    }
}

fn manhattan_dist(p1: &Point2D, p2: &Point2D) -> i32 {
    (p1.x - p2.x).abs() + (p1.y - p2.y).abs()
}

#[test]
fn sanity() {
    let deg: isize = -10;
    assert_eq!(350, deg.rem_euclid(360));
}

fn parse_instructions(i: &str) -> Vec<Instruction> {
    i.lines()
        .map(|l| {
            let action = &l[0..1];
            let value = (&l[1..]).parse::<i32>().unwrap();
            use Instruction::*;
            match action {
                "N" => N(value),
                "S" => S(value),
                "E" => E(value),
                "W" => W(value),
                "L" => L(value),
                "R" => R(value),
                "F" => F(value),
                _ => panic!(format!("Unknown instruction {}", action)),
            }
        })
        .collect()
}

#[test]
fn testing() {
    let i = "F10
N3
F7
R90
F11";
    let instructions = parse_instructions(i);
    println!("{:?}", instructions);
    let mut ship = Ship::new();
    for i in instructions {
        ship.process(&i);
    }
    let origin = Point2D { x: 0, y: 0 };
    assert_eq!(25, manhattan_dist(&origin, &ship.position));
}
