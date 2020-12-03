use std::fs;
use regex::Regex;

#[derive(Debug)]
enum Policy {
    RentalPlacePolicy{
        c: char,
        min_count: usize,
        max_count: usize,
    },
    TobogganCorporatePolicy{
        c: char,
        first_index: usize,
        second_index: usize,
    }
}


#[derive(Debug)]
struct Line<'a> {
    policy: Policy,
    pw: &'a str
}

fn is_valid(policy: &Policy, pw: &str) -> bool {
    match policy {
        Policy::RentalPlacePolicy{c, min_count, max_count } => {
            let re = Regex::new(&c.to_string()).unwrap();
            let m = re.captures_iter(pw).count();
            m >= *min_count && m <= *max_count
        },
        Policy::TobogganCorporatePolicy{c, first_index, second_index} => {
            let c1 = pw.chars().nth(first_index - 1).unwrap();
            let c2 = pw.chars().nth(second_index - 1).unwrap();

            (c1 == *c || c2 == *c) && c1 != c2
        },
    }
}

// TODO: understand rust lifetimes enough to make this work 🤯
impl Line<'_> {
    fn is_valid(&self) -> bool {
        is_valid(&self.policy, self.pw)
    }
}

fn part1() {
    let input = fs::read_to_string("input").unwrap();
    let lines_count = input.lines().count();

    // I'm doing this again, because count() does not implemnet copy and moves the iter
    // I'm sure there is better way of doing this, but this is what I can do atm.
    let input = fs::read_to_string("input").unwrap();
    let lines = input.lines();

    // example input line
    // 3-5 f: fgfff
    let pattern = Regex::new(r"^(\d+)-(\d+) (\w): (\w+)$").unwrap();

    // really this boils down to a map | filter | count
    // map being parse the line into concepts
    // filter being: implement the check that char c has to occure min_count to max_count times in
    // pw
    let no_of_valid_pw = lines
        .map(|l| {
            let caps = pattern.captures(l).unwrap();
            // println!("caps: {:#?}", caps);
            let min_count = caps.get(1).unwrap().as_str().parse::<usize>().unwrap();
            let max_count = caps.get(2).unwrap().as_str().parse::<usize>().unwrap();
            let c = caps.get(3).unwrap().as_str().chars().nth(0).unwrap();
            let pw = caps.get(4).unwrap().as_str();
            Line {
                policy: Policy::RentalPlacePolicy{c, min_count, max_count},
                pw
            }
        })
    .filter(|l| l.is_valid())
        .count();

    println!("found {} valid passwords out of {} lines", no_of_valid_pw, lines_count);
}

fn part2() {
    let input = fs::read_to_string("input").unwrap();
    let lines_count = input.lines().count();

    // I'm doing this again, because count() does not implemnet copy and moves the iter
    // I'm sure there is better way of doing this, but this is what I can do atm.
    let input = fs::read_to_string("input").unwrap();
    let lines = input.lines();

    // example input line
    // 3-5 f: fgfff
    let pattern = Regex::new(r"^(\d+)-(\d+) (\w): (\w+)$").unwrap();

    // really this boils down to a map | filter | count
    // map being parse the line into concepts
    // filter being: implement the check that char c has to occure min_count to max_count times in
    // pw
    let no_of_valid_pw = lines
        .map(|l| {
            let caps = pattern.captures(l).unwrap();
            // println!("caps: {:#?}", caps);
            let first_index = caps.get(1).unwrap().as_str().parse::<usize>().unwrap();
            let second_index = caps.get(2).unwrap().as_str().parse::<usize>().unwrap();
            let c = caps.get(3).unwrap().as_str().chars().nth(0).unwrap();
            let pw = caps.get(4).unwrap().as_str();
            Line {
                policy: Policy::TobogganCorporatePolicy{c, first_index, second_index},
                pw
            }
        })
    .filter(|l| l.is_valid())
        .count();

    println!("found {} valid passwords out of {} lines", no_of_valid_pw, lines_count);
}

fn main() {
    println!("RentalPlacePolicy");
    part1();
    println!("TobogganCorporatePolicy");
    part2();
}

