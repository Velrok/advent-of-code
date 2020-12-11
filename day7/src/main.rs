#![feature(split_inclusive)]
use std::str::FromStr;
use std::string::ParseError;
use std::fmt;

#[derive(Debug, Eq, PartialEq, PartialOrd, Ord)]
struct Bag {
    color: String,
    quantity: usize,
}

impl fmt::Display for Bag {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        // Write strictly the first element into the supplied output
        // stream: `f`. Returns `fmt::Result` which indicates whether the
        // operation succeeded or failed. Note that `write!` uses syntax which
        // is very similar to `println!`.
        write!(f, " <{} {} 🛄>", self.quantity, self.color)
    }
}

#[derive(Debug, Eq, PartialEq, PartialOrd, Ord)]
struct BagRule {
    container: Bag,
    contents: Vec<Bag>,
}

fn trim_bags(s: &str) -> String {
    s.trim()
        .replace(" bags", "")
        .replace(" bag", "")
}

impl fmt::Display for BagRule {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        // Write strictly the first element into the supplied output
        // stream: `f`. Returns `fmt::Result` which indicates whether the
        // operation succeeded or failed. Note that `write!` uses syntax which
        // is very similar to `println!`.
        write!(f, "{} -> {:?}", self.container, self.contents.iter().map(|b| format!("{}", b)).collect::<String>())
    }
}

impl FromStr for BagRule {
    type Err = ParseError;

    fn from_str (s: &str) -> Result<Self, Self::Err> {
        // valid rules will produce two entries
        let mut parts = s.split(" contain ");
        // first entry is the containing bag
        let container: String = trim_bags(parts.next().unwrap());
        // next we have a , separated string of bags. Drop the . at the end
        let contents: String = parts.next().unwrap().replace(".","");
        let contents: Vec<Bag> = if contents == "no other bags" {
            Vec::new()
        } else {
            contents.split(", ")
                .map(|s| {
                    let mut split = s.split_inclusive(char::is_numeric);
                    let number = split.next().unwrap();
                    let color = split.next().unwrap();
                    println!("No: '{}'", number);
                    Bag{
                        color: trim_bags(color.trim()),
                        quantity: number.parse::<usize>().unwrap_or(0)
                    }
                }) // ditch the leading numnbers
                .collect()
        };

        Ok(BagRule{
            container: Bag{color: container, quantity: 1},
            contents: contents,
        })
    }
}

#[test]
fn bag_rule_from_str() {
    let r = "light red bags contain 1 bright white bag, 2 muted yellow bags.".parse::<BagRule>().unwrap();
    assert_eq!(BagRule{
        container: Bag{color: "light red".to_string(), quantity: 1},
        contents: vec![
            Bag{color: "bright white".to_string(), quantity: 1},
            Bag{color: "muted yellow".to_string(), quantity: 2}
        ]}, r);
}

#[test]
fn bag_display() {
    assert_eq!(
        format!("{}", Bag{color: "light red".to_string(), quantity: 5}),
        " <5 light red 🛄>"
    );
}


// 'a is to explain to the compiler that rules_found are borrowed form rule_set
fn applicable_rules<'a>(rule_set: &'a Vec<BagRule>, color_backlog: Vec<&str>, rules_found: Vec<&'a BagRule>) -> Vec<&'a BagRule> {
    // println!("b: {:#?}, rules: {:#?}", color_backlog, rules_found);
    if color_backlog.is_empty() {
        return rules_found;
    }

    let x: Vec<_> = rule_set.iter()
        .filter(|r| {
            r.contents.iter()
                .filter(|b| b.color == color_backlog[0].to_string())
                .count() > 0
        })
        .collect();

    let mut r_found_next = rules_found.iter().cloned().chain(x.iter().cloned()).collect::<Vec<&'a BagRule>>();
    r_found_next.sort();
    r_found_next.dedup();

    applicable_rules(
        rule_set,
        color_backlog[1..].iter().cloned().chain(x.iter().map(|r| r.container.color.as_str())).collect(),
        r_found_next
    )
}


#[test]
fn testing() {
    let input = "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.";

    let rules: Vec<_> = input.lines()
        .map(|l| l.parse::<BagRule>().unwrap())
        .collect();
    // println!("Bag: {:#?}", rules);
    let applicable = applicable_rules(
        &rules,
        vec!["shiny gold"],
        Vec::new());
    println!("applicable_rules");
    for r in &applicable {
        println!("{}", r);
    }
    assert_eq!(4, applicable.len());
}

fn part1(input: &str) {
    let rules: Vec<_> = input.lines()
        .map(|l| l.parse::<BagRule>().unwrap())
        .collect();

    let applicable = applicable_rules(
        &rules,
        vec!["shiny gold"],
        Vec::new());

    println!("part 1");
    for r in &applicable {
        println!("{}", r);
    }
    println!("applicable rules -> {}", applicable.len());
}

fn main() {
    println!("Day 7");
    let input = include_str!("../input");
    // testing();
    part1(input);
}
