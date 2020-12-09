const ROW_COUNT : usize = 128;
const COLUMN_COUNT : usize = 8;

#[derive(Debug, PartialEq)]
struct Seat {
    row: usize,
    column: usize,
}

impl Seat {
    fn id (&self) -> usize {
        self.row * 8 + self.column
    }
}

fn find_row(row_spec: &str) -> usize {
    let rows: Vec<usize> = (0..ROW_COUNT).collect();
    let row_range = row_spec.chars().fold(rows, |acc, fb|{
        let l = acc.len();
        match fb {
            'B' => acc.into_iter().skip(l / 2).collect(),
            'F' => acc.into_iter().take(l / 2).collect(),
            _ => panic!(),
        }
    });
    assert_eq!(1, row_range.len());
    row_range[0]
}

fn find_col(col_spec: &str) -> usize {
    let cols: Vec<usize> = (0..COLUMN_COUNT).collect();
    let col_range = col_spec.chars().fold(cols, |acc, rl|{
        let l = acc.len();
        match rl {
            'R' => acc.into_iter().skip(l / 2).collect(),
            'L' => acc.into_iter().take(l / 2).collect(),
            _ => panic!(),
        }
    });
    assert_eq!(1, col_range.len());
    col_range[0]
}


fn parse_seat_spec(spec: &str) -> Seat {
    let (row_spec, col_spec) = spec.split_at(spec.len() - 3);
    Seat{row: find_row(row_spec), column: find_col(col_spec)}
}

#[test]
fn test() {
    assert_eq!(Seat{row:  70, column: 7}, parse_seat_spec("BFFFBBFRRR"));
    assert_eq!(Seat{row:  70, column: 7}.id(), 567);
    assert_eq!(Seat{row:  14, column: 7}, parse_seat_spec("FFFBBBFRRR"));
    assert_eq!(Seat{row:  14, column: 7}.id(), 119);
    assert_eq!(Seat{row: 102, column: 4}, parse_seat_spec("BBFFBBFRLL"));
}

fn part1(i: &str) {
    let highest_seat_id = i.lines()
        .map(parse_seat_spec)
        .map(|s| s.id())
        .max()
        .unwrap();
    println!("highest_seat_id: {}", highest_seat_id);
}

fn part2(i: &str) {
    let mut seats: Vec<_> = i.lines().map(parse_seat_spec).map(|s| s.id()).collect();
    seats.sort();

    let my_seat_id = seats.iter().zip(seats.iter().skip(1))
        .fold(0, |acc, (&a_id, &b_id)| {
            match a_id + 1 == b_id {
                true => acc,
                false => a_id + 1,
            }
        });
    println!("my seat id: {}", my_seat_id);
}

fn main() {
    // TODO: implement FromStr trait
    // let my_seat:Seat = "BBFFBBFRLL".parse::<Seat>();
    let input = include_str!("../input");
    part1(input);
    part2(input);
}
