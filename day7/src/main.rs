use std::str::FromStr;
use std::string::ParseError;

#[derive(Debug, Eq, PartialEq)]
struct Bag {
    color: String,
}

#[derive(Debug, PartialEq)]
struct BagRule {
    container: Bag,
    contents: Vec<Bag>,
}

fn trim_bags(s: &str) -> String {
    s.trim()
        .replace(" bags", "")
        .replace(" bag", "")
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
                .map(|s| trim_bags(s.split(char::is_numeric).nth(1).unwrap().trim())) // ditch the leading numnbers
                .map(|c| Bag{color: c}) // make Bags
                .collect()
        };

        Ok(BagRule{
            container: Bag{color: container},
            contents: contents,
        })
    }
}

#[test]
fn bag_rule_from_str() {
    let r = "light red bags contain 1 bright white bag, 2 muted yellow bags.".parse::<BagRule>().unwrap();
    assert_eq!(BagRule{
        container: Bag{color: "light red".to_string()},
        contents: vec![
            Bag{color: "bright white".to_string()},
            Bag{color: "muted yellow".to_string()}
        ]}, r);
}

// 'a is to explain to the compiler that rules_found are borrowed form rule_set
fn applicable_rules<'a>(rule_set: &'a Vec<BagRule>, color_backlog: Vec<&str>, rules_found: Vec<&'a BagRule>) -> Vec<&'a BagRule> {
    // TODO got too many rules! return 6 shoudl be 4
    println!("b: {:#?}, rules: {:#?}", color_backlog, rules_found);
    if color_backlog.is_empty() {
        return rules_found;
    }

    let x: Vec<_> = rule_set.iter()
        .filter(|r| r.contents.contains(&Bag{color: color_backlog[0].to_string()}))
        .collect();

    applicable_rules(
        rule_set,
        color_backlog[1..].iter().cloned().chain(x.iter().map(|r| r.container.color.as_str())).collect(),
        rules_found.iter().cloned().chain(x.iter().cloned()).collect()
    )
}

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
    println!("applicable_rules : {:#?}", applicable_rules(
            &rules,
            vec!["shiny gold"],
            Vec::new()
            ).len());
}

fn main() {
    println!("Day 7");
    testing();
}
