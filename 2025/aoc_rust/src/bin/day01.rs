use std::fs;

type DialCount = i16;
const DIAL_SIZE: DialCount = 100;
const DIAL_START: DialCount = 50;

fn main() {
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
    print!("{password}")
}

fn turn_left(current: DialCount, rotation: DialCount) -> DialCount {
    (current - rotation) % DIAL_SIZE
}

fn turn_right(current: DialCount, rotation: DialCount) -> DialCount {
    (current + rotation) % DIAL_SIZE
}
