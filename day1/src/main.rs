use std::fs;

fn main() {
    let input = fs::read_to_string("input");
    let lines = input.unwrap().lines();
    // let numbers = lines.map(|&l| l.parse::<u32>().unwrap()).collect();
}
