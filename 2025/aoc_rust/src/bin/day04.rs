use std::collections::HashSet;
use std::fs;

#[derive(PartialEq, Eq, Hash, Debug, Clone, Copy)]
struct Roll {
    x: usize,
    y: usize,
}

fn main() {
    println!("part 1");
    let input = fs::read_to_string("inputs/day04").unwrap();
    let rolles = extract_rolles(&input);
    let (width, height) = dimensions(&input);
    dbg!(count_accessable_rolles(&rolles, width, height));
}

fn count_accessable_rolles(rolles: &HashSet<Roll>, width: usize, height: usize) -> usize {
    rolles
        .iter()
        .filter(|&&roll| neighbour_count(roll, rolles, width, height) < 4)
        .count()
}

fn neighbour_count(roll: Roll, rolles: &HashSet<Roll>, width: usize, height: usize) -> usize {
    const KERNEL: [isize; 3] = [-1, 0, 1];
    let mut counter = 0;
    for dy in KERNEL {
        for dx in KERNEL {
            if (dx, dy) == (0, 0) {
                continue;
            }

            let x = (roll.x as isize) + dx;
            let y = (roll.y as isize) + dy;

            if x < 0 || y < 0 || (x as usize) >= width || (y as usize) >= height {
                continue;
            }

            if rolles.contains(&Roll {
                x: x.try_into().unwrap(),
                y: y.try_into().unwrap(),
            }) {
                counter += 1;
            }
        }
    }
    counter
}

fn dimensions(input: &str) -> (usize, usize) {
    (
        input.lines().count(),
        input.lines().next().unwrap().chars().count(),
    )
}
fn extract_rolles(input: &str) -> HashSet<Roll> {
    let mut rolles = HashSet::new();

    for (y, line) in input.lines().enumerate() {
        for (x, c) in line.chars().enumerate() {
            let roll = Roll { x, y };
            if c == '@' {
                rolles.insert(roll);
            }
        }
    }
    rolles
}
