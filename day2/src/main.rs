use std::fs;
use regex::Regex;

struct Policy {
    c: char,
    min_count: u32,
    max_count: u32,
}

struct Line<'a> {
    policy: Policy,
    pw: &'a str,
}

impl Line<'a> {
    fn is_valid(&self) -> bool {
        false
    }
}

fn main() {
    let input = fs::read_to_string("input").unwrap();
    let lines = input.lines();

    // example input line
    // 3-5 f: fgfff
    let pattern = Regex::new(r"^(\d+)-(\d+) (\w): (\w+)$").unwrap();
    // note using .nth(0) here because I can't see neither first nor head (but last is available?)
    // also next() requires a mutable instance (i'm not keen on advancing the inner state of the
    // iter)
    let _x:Vec<Line> = lines.map(|l| {
            let caps = pattern.captures(l).unwrap();
            let min_count = caps.get(0).unwrap().as_str().parse::<u32>().unwrap();
            let max_count = caps.get(1).unwrap().as_str().parse::<u32>().unwrap();
            let c = caps.get(2).unwrap().as_str().chars().nth(0).unwrap();
            let pw = caps.get(3).unwrap().as_str();
            Line {
                policy: Policy {c, min_count, max_count},
                pw
            }
        }).collect();
}

