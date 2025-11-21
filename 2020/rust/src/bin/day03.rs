
// Starting at the top-left corner of your map and following a slope
// of right 3 and down 1, how many trees would you encounter?
// input:
//
// ..#...##...###.........#..#..#.
// #.###........#..##.#......#...#
// #.#.###..#.#..#.#............#.
// .##............#......#...#.#..
// ..#..#.....##..##..##..........

struct Slope {
    dx: usize,
    dy: usize,
}

fn main() {
    // let input = fs::read_to_string("inputs/day03.txt").unwrap();
    let input = include_str!("../../inputs/day03.txt");
    println!("part 1: {}", traverse_field(input, Slope {dx: 3, dy: 1}));
    println!("part 2: {}",
        traverse_field(input, Slope{dx: 1, dy: 1})
        * traverse_field(input, Slope{dx: 3, dy: 1})
        * traverse_field(input, Slope{dx: 5, dy: 1})
        * traverse_field(input, Slope{dx: 7, dy: 1})
        * traverse_field(input, Slope{dx: 1, dy: 2}));
}

fn traverse_field(field: &str, slope: Slope) -> usize {
    let height: usize = field.lines().count();
    let lines: Vec<_> = field.lines().collect();
    let width = lines.iter().nth(0).unwrap().len();

    let mut x = 0;
    let mut y = 0;
    let mut tree_count = 0;
    while y < height {
        let c: char = lines.iter().nth(y).unwrap().chars().nth(x).unwrap();
        // println!("c: {} || w: {}, h: {}, x: {}, y: {}", c, width, height, x, y);
        if c == '#' {tree_count += 1};
        x = (x + slope.dx) % width;
        y = y + slope.dy;
        // let c = *lines.nth(y).unwrap().chars().nth(x % width).unwrap();
    }
    tree_count
}


#[test]
fn testing_part1 () {
    let input = "..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#";
    let count = traverse_field(input, Slope{dx: 3, dy: 1});
    assert_eq!(count, 7);

}

#[test]
fn testing_part2 () {
    let input = "..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#";
    assert_eq!(2, traverse_field(input, Slope{dx: 1, dy: 1}));
    assert_eq!(7, traverse_field(input, Slope{dx: 3, dy: 1}));
    assert_eq!(3, traverse_field(input, Slope{dx: 5, dy: 1}));
    assert_eq!(4, traverse_field(input, Slope{dx: 7, dy: 1}));
    assert_eq!(2, traverse_field(input, Slope{dx: 1, dy: 2}));
}
