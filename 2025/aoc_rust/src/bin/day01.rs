use std::fs;

type DialCount = i32;
const DIAL_SIZE: DialCount = 100;
const DIAL_START: DialCount = 50;

fn main() {
    part1();
    part2();
}

fn part1() {
    let input = fs::read_to_string("inputs/day01.txt").unwrap();
    let lines = input.lines();

    let mut dial_pos = DIAL_START;
    let mut password = 0;

    for line in lines {
        let mut chars = line.chars();
        let direction = chars.next();
        let rotation = chars.collect::<String>().parse::<DialCount>().unwrap();

        let new_pos = match direction {
            Some('L') => turn_left(dial_pos, rotation),
            Some('R') => turn_right(dial_pos, rotation),
            _ => panic!("unexpected direction"),
        };

        if new_pos == 0 {
            password += 1
        }

        dial_pos = new_pos;
    }
    println!("P1: {password}")
}

fn turn_left(current: DialCount, rotation: DialCount) -> DialCount {
    (current - rotation) % DIAL_SIZE
}

fn turn_right(current: DialCount, rotation: DialCount) -> DialCount {
    (current + rotation) % DIAL_SIZE
}

fn part2() {
    let input = fs::read_to_string("inputs/day01.txt").unwrap();
    let lines = input.lines();

    let mut dial_pos = DIAL_START;
    let mut password = 0;

    for line in lines {
        let mut chars = line.chars();
        let direction = chars.next();
        let rotation = chars.collect::<String>().parse::<DialCount>().unwrap();

        let (new_pos, full_rotations) = match direction {
            Some('L') => turn_left_2(dial_pos, rotation),
            Some('R') => turn_right_2(dial_pos, rotation),
            _ => panic!("unexpected direction"),
        };

        password += full_rotations;

        dial_pos = new_pos;
    }
    println!("P2: {password}")
}

fn turn_left_2(dial_pos: DialCount, rotation: DialCount) -> (DialCount, DialCount) {
    let new_pos = dial_pos - rotation;
    (new_pos % DIAL_SIZE, full_rotations(dial_pos, new_pos))
}

fn turn_right_2(dial_pos: DialCount, rotation: DialCount) -> (DialCount, DialCount) {
    let new_pos = dial_pos + rotation;
    (new_pos % DIAL_SIZE, full_rotations(dial_pos, new_pos))
}

fn full_rotations(old_pos: DialCount, new_pos: DialCount) -> DialCount {
    (new_pos / DIAL_SIZE).abs()
        + if old_pos.signum() != new_pos.signum() {
            1
        } else {
            0
        }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_full_rotations() {}
}
