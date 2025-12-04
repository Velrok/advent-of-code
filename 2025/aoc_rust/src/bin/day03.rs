use std::fs;

struct Bank {
    batteries: Vec<u8>,
}

fn main() {
    let input = fs::read_to_string("inputs/day03.txt").unwrap();
    let result: u32 = input.lines().map(parse_bank).map(find_max_joltage).sum();
    println!("P1: {result:?}");
}

fn parse_bank(str: &str) -> Bank {
    let batteries: Vec<u8> = str.chars().map(|c| (c as u8) - b'0').collect();
    Bank {
        batteries: batteries,
    }
}

fn find_max_joltage(bank: Bank) -> u32 {
    let Some((index, first_biggest)) = bank.batteries[..(bank.batteries.len() - 1)]
        .iter()
        .enumerate()
        .max_by_key(|(_, &battery)| battery)
    else {
        panic!("Have to find at least one battery on first run")
    };
    let second_biggest = bank.batteries[(index + 1)..].iter().max().unwrap();
    (*first_biggest as u32) * 10 + (*second_biggest as u32)
}
// 987654321111111
// 811111111111119
// 234234234234278
// 818181911112111
