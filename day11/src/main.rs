use std::error::Error;
use std::fmt;
use std::str::FromStr;

#[derive(PartialEq, Eq, Debug, Clone)]
enum Position {
    Floor,
    Occupied,
    Empty,
}

impl fmt::Display for Position {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let out = match self {
            Position::Floor => ".",
            Position::Occupied => "#",
            Position::Empty => "L",
        };
        write!(f, "{}", out)
    }
}

#[derive(PartialEq, Eq, Debug, Clone)]
struct SeatLayout {
    positions: Vec<Position>,
    width: usize,
}

#[derive(Debug)]
struct SeatLayoutParseError;
impl Error for SeatLayoutParseError {}

impl fmt::Display for SeatLayoutParseError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Invalid SeatLayout, not helpful I know XD")
    }
}

impl FromStr for SeatLayout {
    type Err = SeatLayoutParseError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let lines: Vec<_> = s.lines().collect();
        let width = lines[0].len();
        let positions: Vec<Position> = lines
            .iter()
            .flat_map(|l| {
                l.chars().map(|c| match c {
                    'L' => Position::Empty,
                    '.' => Position::Floor,
                    '#' => Position::Occupied,
                    _ => panic!("Can't parse this!!! HAMMER TIME!"),
                })
            })
            .collect();
        Ok(SeatLayout { positions, width })
    }
}

impl fmt::Display for SeatLayout {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let mut out = String::from("\n");
        for c in self.positions[..].chunks(self.width) {
            for p in c {
                out.push_str(format!("{}", p).as_str());
            }
            out.push_str("\n");
        }
        write!(f, "{}", out)
    }
}

#[derive(PartialEq, Eq, Debug, Clone, Copy)]
struct Point1D {
    idx: usize,
    field_width: usize,
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

fn to_2d(p: &Point1D) -> Point2D {
    Point2D {
        x: p.idx.rem_euclid(p.field_width) as i32,
        y: p.idx.div_euclid(p.field_width) as i32,
    }
}

fn to_1d(p: &Point2D, sl: &SeatLayout) -> Option<Point1D> {
    if p.x < 0 || p.y < 0 {
        return None;
    }

    let h = sl.positions.len() / sl.width;

    if p.x >= sl.width as i32 || p.y >= h as i32 {
        return None;
    }

    Some(Point1D {
        field_width: sl.width,
        idx: (p.y * (sl.width as i32) + p.x) as usize,
    })
}

#[test]
fn point_addition() {
    let p1 = Point2D { x: -1, y: -1 };
    let p2 = Point2D { x: 10, y: 11 };
    let p3 = p2 + p1;
    assert_eq!(p3, Point2D { x: 9, y: 10 });
}

fn no_of_adjacent_occupied_positions(sl: &SeatLayout, idx: usize) -> usize {
    let center = to_2d(&Point1D {
        idx,
        field_width: sl.width,
    });
    let mut neightbours: Vec<_> = Vec::new();
    for dy in -1..2 {
        for dx in -1..2 {
            if !(dx == 0 && dy == 0) {
                neightbours.push(center + Point2D { x: dx, y: dy });
            }
        }
    }

    neightbours
        .iter()
        .map(|p| to_1d(p, sl))
        .filter(|o| match o {
            None => false,
            _ => true,
        })
        .map(|o| o.unwrap().idx)
        .map(|i| match sl.positions[i] {
            Position::Occupied => 1,
            _ => 0,
        })
        .sum()
}

#[test]
fn neightbours_test() {
    let layout = "#.#
...
.#."
    .parse::<SeatLayout>()
    .unwrap();
    //assert_eq!(0, no_of_adjacent_occupied_positions(&layout, 0)); // top left
    assert_eq!(3, no_of_adjacent_occupied_positions(&layout, 4)); // middle middle

    //assert_eq!(2, no_of_adjacent_occupied_positions(&layout, 3)); // middle left
    //assert_eq!(1, no_of_adjacent_occupied_positions(&layout, 8)); // bottom right
}

fn next_state(sl: &SeatLayout) -> SeatLayout {
    let mut positions: Vec<Position> = Vec::new();
    let mut i = 0;

    for p in &sl.positions {
        let occupied_count = no_of_adjacent_occupied_positions(sl, i);
        let new_p = match p {
            Position::Floor => Position::Floor,
            Position::Occupied => {
                if occupied_count >= 4 {
                    Position::Empty
                } else {
                    Position::Occupied
                }
            }
            Position::Empty => {
                if occupied_count == 0 {
                    Position::Occupied
                } else {
                    Position::Empty
                }
            }
        };
        positions.push(new_p);
        i += 1;
    }
    SeatLayout {
        positions,
        width: sl.width,
    }
}

fn main() {
    // parse map
    // get_adjacent
    // get_follow
    //
    // Rules:
    // If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
    // If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
    // Otherwise, the seat's state does not change.
}

#[test]
fn test1() {
    let input = "L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL";

    let step_1 = "#.##.##.##
#######.##
#.#.#..#..
####.##.##
#.##.##.##
#.#####.##
..#.#.....
##########
#.######.#
#.#####.##"
        .parse::<SeatLayout>()
        .unwrap();

    let layout = input.parse::<SeatLayout>().unwrap();

    println!("SeatLayout: --{}--", layout);
    let layout_1 = next_state(&layout);
    println!("SeatLayout Step 1: --{}--", layout_1);
    assert_eq!(step_1, layout_1);
}
