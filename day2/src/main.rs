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

// TODO: understand rust lifetimes enough to make this work 🤯
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

    // really this boils down to a map | filter | count
    // map being parse the line into concepts
    // filter being: implement the check that char c has to occure min_count to max_count times in
    // pw
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

