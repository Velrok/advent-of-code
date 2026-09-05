use std::fs;

fn main() {
    let input = fs::read_to_string("inputs/day01.txt").unwrap();
    println!("{} chars read", input.len());
}
