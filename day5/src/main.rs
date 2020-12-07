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
    let row_range = row_spec.chars().fold(rows, |range, fb|{
        let l = range.len();
        match fb {
            'B' => range.into_iter().skip(l / 2).collect(),
            'F' => range.into_iter().take(l / 2).collect(),
            _ => panic!(),
        }
    });
    assert_eq!(1, row_range.len());
    row_range[0]
}

fn find_col(col_spec: &str) -> usize {
    let cols: Vec<usize> = (0..COLUMN_COUNT).collect();
    let col_range = col_spec.chars().fold(cols, |range, rl|{
        let l = range.len();
        match rl {
            'R' => range.into_iter().skip(l / 2).collect(),
            'L' => range.into_iter().take(l / 2).collect(),
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

fn main() {
    let input = include_str!("../input");
    let highest_seat_id = input.lines()
        .map(parse_seat_spec)
        .map(|s| s.id())
        .max()
        .unwrap();
    println!("highest_seat_id: {}", highest_seat_id);
}

