use std::error::Error;
use std::fmt;
use std::str::FromStr;

#[derive(PartialEq, Eq, Debug)]
enum Position {
    Floor,
    Occupied,
    Empty,
}

#[derive(PartialEq, Eq, Debug)]
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
                    _ => panic!("Can't parse this!!! HAMMER TIME!"),
                })
            })
            .collect();
        Ok(SeatLayout { positions, width })
    }
}

fn no_of_adjacent_occupied_positions(sl: &SeatLayout, idx: usize) -> usize {
    42
}

fn next_state(sl: &SeatLayout, idx: usize) -> Position {
    Position::Floor
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

    println!("SeatLayout: {:?}", input.parse::<SeatLayout>());
}
